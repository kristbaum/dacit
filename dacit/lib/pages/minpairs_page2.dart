import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:dacit/main.dart';
import 'package:dacit/services/globals.dart';
import 'package:dacit/services/min_pair.dart';
import 'package:dacit/services/text_stimulus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:dacit/services/audio_player.dart';
import 'package:dacit/services/recorder.dart';

class MinimalPairsPage extends StatefulWidget {
  const MinimalPairsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MinimalPairsPageState();
}

class _MinimalPairsPageState extends State<MinimalPairsPage> {
  bool _showPlayer = false;
  late MinPair minPair;
  bool _loadNewMP = true;
  String? _audioPath;

  @override
  void initState() {
    _showPlayer = false;
    super.initState();
    //futureTextStimulus = fetchTextStimulus();
  }

  Future<void> _refreshMinPair() async {
    setState(() {
      _showPlayer = false;
      _loadNewMP = true;
      _audioPath = null;
    });
  }

  Future<MinPair> _fetchMinPair() async {
    final response = await http.get(
      Uri.parse('${baseDomain}api/minpair'),
      headers: {
        "Authorization": "Token ${user.token}",
      },
    );

    if (response.statusCode == 200) {
      log.info("Downloading new Minpair");
      return MinPair.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load new text');
    }
  }

  Future<void> _uploadAudio(String path, int id) async {
    log.info("Try uploading this file: $path with this id: $id");
    final file = XFile(path);

    final request = http.MultipartRequest(
        'POST', Uri.parse('${baseDomain}api/upload/$id/'));

    request.headers.addAll({"Authorization": "Token ${user.token}"});
    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();

    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      fileLength,
      filename: "user_audio.wav",
    );
    request.files.add(multipartFile);

    log.info(request.files.toString());

    final response = await request.send();
    if (response.statusCode == 201) {
      log.info('File uploaded successfully');
    } else {
      log.warning('Error uploading file: ${response.statusCode}');
    }
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(25.0),
                child: const Text("Welches:")),
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: _loadNewMP
                  ? FutureBuilder<MinPair>(
                      future: _fetchMinPair(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          minPair = snapshot.data!;
                          return Text(snapshot.data!.category);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    )
                  : Text(minPair.secondStimulus),
            ),
            _showPlayer
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: AudioPlayer(
                        source: _audioPath!,
                        onDelete: () {
                          setState(() {
                            //ts = ts;
                            _loadNewMP = false;
                            _showPlayer = false;
                          });
                        },
                      ),
                    ),
                    if (_audioPath != null)
                      IconButton(
                        onPressed: () {
                          _uploadAudio(_audioPath!, minPair.id);
                          _refreshMinPair();
                        },
                        icon: const Icon(
                          Icons.check,
                        ),
                      ),
                  ])
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    AudioRecorder(
                      onStop: (path) {
                        log.info('Recorded file path: $path');
                        setState(() {
                          _audioPath = path;
                          //ts = ts;
                          _loadNewMP = false;
                          _showPlayer = true;
                        });
                      },
                    ),
                    IconButton(
                      onPressed: _refreshMinPair,
                      icon: const Icon(
                        Icons.skip_next,
                      ),
                    ),
                  ])
          ],
        )));
  }
}
