import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:dacit/main.dart';
import 'package:dacit/services/globals.dart';
import 'package:dacit/services/text_stimulus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:dacit/services/audio_player.dart';
import 'package:dacit/services/recorder.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool _showPlayer = false;
  late TextStimulus ts;
  bool _loadNewTs = true;
  String? _audioPath;

  @override
  void initState() {
    _showPlayer = false;
    super.initState();
    //futureTextStimulus = fetchTextStimulus();
  }

  Future<void> _refreshTextStimulus() async {
    setState(() {
      _showPlayer = false;
      _loadNewTs = true;
      _audioPath = null;
    });
  }

  Future<TextStimulus> _fetchTextStimulus() async {
    final response = await http.get(
      Uri.parse('${baseDomain}api/sts'),
      headers: {
        "Authorization": "Token ${user.token}",
      },
    );

    if (response.statusCode == 200) {
      log.info("Downloading new Stimulus");
      return TextStimulus.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
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
                child: Text(AppLocalizations.of(context).recordThisWord)),
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              child: _loadNewTs
                  ? FutureBuilder<TextStimulus>(
                      future: _fetchTextStimulus(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          ts = snapshot.data!;
                          return Text(snapshot.data!.stimulus);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    )
                  : Text(ts.stimulus),
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
                            _loadNewTs = false;
                            _showPlayer = false;
                          });
                        },
                      ),
                    ),
                    if (_audioPath != null)
                      IconButton(
                        onPressed: () {
                          _uploadAudio(_audioPath!, ts.id);
                          _refreshTextStimulus();
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
                          _loadNewTs = false;
                          _showPlayer = true;
                        });
                      },
                    ),
                    IconButton(
                      onPressed: _refreshTextStimulus,
                      icon: const Icon(
                        Icons.skip_next,
                      ),
                    ),
                  ])
          ],
        )));
  }
}
