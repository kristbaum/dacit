import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:just_audio/just_audio.dart' as ap;
import 'package:record/record.dart';
import 'package:dacit/audio_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recordAudio),
      ),
      body: Center(child: RecorderApp()),
    );
  }
}

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({Key? key, required this.onStop}) : super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRecordStopControl(),
                const SizedBox(width: 20),
                _buildPauseResumeControl(),
                const SizedBox(width: 20),
                _buildText(),
              ],
            ),
            if (_amplitude != null) ...[
              const SizedBox(height: 40),
              Text('Current: ${_amplitude?.current ?? 0.0}'),
              Text('Max: ${_amplitude?.max ?? 0.0}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording || _isPaused) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (!_isPaused) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.onStop(path!);

    setState(() => _isRecording = false);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}

/* upload(File imageFile) async {
  // open a bytestream
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  var uri = Uri.parse("http://ip:8082/composer/predict");

  // create multipart request
  var request = new http.MultipartRequest("POST", uri);

  // multipart that takes file
  //var multipartFile = new http.MultipartFile('file', stream, length,
  //    filename: basename(imageFile.path));

  // add file to multipart
  //request.files.add(multipartFile);

  // send
  var response = await request.send();
  print(response.statusCode);

  // listen for response
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
} */

class TextStimulus {
  final int id;
  final String text;

  const TextStimulus({
    required this.id,
    required this.text,
  });
}

class RecorderApp extends StatefulWidget {
  const RecorderApp({Key? key}) : super(key: key);

  @override
  _RecorderAppState createState() => _RecorderAppState();
}

class _RecorderAppState extends State<RecorderApp> {
  bool showPlayer = false;
  ap.AudioSource? audioSource;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  Future<List<TextStimulus>> getRequest() async {
    log("Bla1");
    var url = Uri.parse("http://localhost:5002/api/ts/");
    final response = await http.get(url);
    var responseData = json.decode(response.body);
    List<TextStimulus> textStimuli = [];
    for (var stimulus in responseData) {
      TextStimulus textStimulus =
          TextStimulus(id: stimulus["id"], text: stimulus["text"]);

      //Adding user to the list.
      textStimuli.add(textStimulus);
    }
    return textStimuli;
  }

  Future<TextStimulus> getTextStimulus() async {
    log("Bla1");
    var url = Uri.parse("http://localhost:5002/api/sts/");
    final response = await http.get(url);
    var responseData = json.decode(response.body);
    TextStimulus textStimulus =
        TextStimulus(id: responseData["id"], text: responseData["text"]);

    return textStimulus;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: <Widget>[
          Expanded(
            child: showPlayer
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AudioPlayer(
                      source: audioSource!,
                      onDelete: () {
                        setState(() => showPlayer = false);
                      },
                    ),
                  )
                : AudioRecorder(
                    onStop: (path) {
                      setState(() {
                        log(path);
                        audioSource = ap.AudioSource.uri(Uri.parse(path));
                        showPlayer = true;
                      });
                    },
                  ),
          ),
          IconButton(
            icon: const Icon(Icons.get_app),
            tooltip: 'Test connection',
            onPressed: () {
              getRequest();
            },
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: getTextStimulus(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Text(snapshot.data.text);
                  }
                },
                // builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                //   if (snapshot.data == null) {
                //     return Container(
                //       child: Center(
                //         child: CircularProgressIndicator(),
                //       ),
                //     );
                //   } else {
                //     return ListView.builder(
                //       itemCount: snapshot.data.length,
                //       itemBuilder: (ctx, index) => ListTile(
                //         title: Text(snapshot.data[index].text),
                //         subtitle: Text(snapshot.data[index].id.toString()),
                //         contentPadding: EdgeInsets.only(bottom: 20.0),
                //       ),
                //     );
                //   }
                // },
              ),
            ),
          )
        ],
      )),
    );
  }
}
