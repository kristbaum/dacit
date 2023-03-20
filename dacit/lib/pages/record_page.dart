import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:dacit/main.dart';
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
  late int tsId;

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
                    tsId = snapshot.data!.id;
                    return Text(snapshot.data!.stimulus);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
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
                      uploadAudio(path, tsId);
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

  if (response.statusCode == 200) {
    return TextStimulus.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load new text');
  }
}

Future<void> uploadAudio(String path, int id) async {
  log.info(
      "Try uploading this file: $path with this id: $id");
  final file = XFile(path);

  final request =
      http.MultipartRequest('PUT', Uri.parse('${baseDomain}api/upload/$id/'));

  request.headers.addAll({"Authorization": "Token ${user.token}"});
  final fileStream = http.ByteStream(file.openRead());
  final fileLength = await file.length();

  final multipartFile = http.MultipartFile(
    'file',
    fileStream,
    fileLength,
    filename: file.name,
  );
  request.files.add(multipartFile);

  final response = await http.Client().send(request);
  if (response.statusCode == 201) {
    log.info('File uploaded successfully');
  } else {
    log.warning('Error uploading file: ${response.statusCode}');
  }
}
