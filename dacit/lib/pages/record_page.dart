import 'dart:convert';
import 'dart:io';
import 'package:dacit/services/globals.dart';
import 'package:dacit/services/text_stimulus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'package:dacit/services/audio_player.dart';
import 'package:dacit/services/recorder.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  bool showPlayer = false;
  String? audioPath;
  late Future<TextStimulus> futureTextStimulus;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
    futureTextStimulus = fetchTextStimulus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).recordAudio),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(25.0),
                child: const Text("Nehmen Sie das folgende Wort auf:")),
            Container(
              padding: const EdgeInsets.all(25.0),
              child: FutureBuilder<TextStimulus>(
                future: futureTextStimulus,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.stimulus);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              // Text("Apfelstrudel",
              //     style: DefaultTextStyle.of(context)
              //         .style
              //         .apply(fontSizeFactor: 3.0)),
            ),
            showPlayer
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AudioPlayer(
                      source: audioPath!,
                      onDelete: () {
                        setState(() => showPlayer = false);
                      },
                    ),
                  )
                : Expanded(child: AudioRecorder(
                    onStop: (path) {
                      if (kDebugMode) print('Recorded file path: $path');
                      setState(() {
                        audioPath = path;
                        showPlayer = true;
                      });
                      uploadFile(path);
                    },
                  )),
          ],
        )));
  }
}

Future<TextStimulus> fetchTextStimulus() async {
  final response = await http.get(
    Uri.parse('${baseDomain}api/sts'),
    headers: {
      "Authorization": "Token ${user.token}",
    },
  );
  print("Token ${user.token}");
  print(response.body);

  if (response.statusCode == 200) {
    print("OK");
    return TextStimulus.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load new text');
  }
}

Future<void> uploadFile(File file) async {
  final request = http.MultipartRequest(
      'POST', Uri.parse("http://localhost:8000/api/upload/"));
  final fileStream = http.ByteStream(file.openRead());
  final fileLength = await file.length();

  final multipartFile = http.MultipartFile(
    'file',
    fileStream,
    fileLength,
    filename: file.name,
  );
  request.files.add(multipartFile);

  request.fields['id'] = "testid";

  final response = await sendRequest(request);
  if (response.statusCode == 201) {
    print('File uploaded successfully');
  } else {
    print('Error uploading file: ${response.statusCode}');
  }
}

Future<http.StreamedResponse> sendRequest(http.BaseRequest request) {
  if (kIsWeb) {
    // Use the `http` package's browser client for web
    return http.browserClient.send(request);
  } else {
    // Use the regular `http` package client for other platforms
    return http.Client().send(request);
  }
}

