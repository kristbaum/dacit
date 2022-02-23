import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dacit/minimal_pairs_page.dart';
import 'package:dacit/record_audio.dart';
import 'package:dacit/settings_page.dart';
import 'package:dacit/speaker_dis_page.dart';
import 'package:dacit/about_page.dart';
import 'package:record/record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dacit',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DacitPage(title: 'Dacit'),
      routes: {
        '/minpairs': (context) => MinimalPairs(),
        '/record': (context) => RecordPage(),
        '/settings': (context) => Settings(),
        '/speakerdis': (context) => SpeakerDis(),
        '/about': (context) => About()
      },
      // home: Main(),
    );
  }
}

class DacitPage extends StatefulWidget {
  DacitPage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _DacitPageState createState() => _DacitPageState();
}

class _DacitPageState extends State<DacitPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Click me",
                style: TextStyle(fontSize: 30, fontStyle: FontStyle.normal),
              ),
              ElevatedButton(
                child: Text(
                  "Click Here",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () => {},
              ),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

upload(File imageFile) async {
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
}

Widget drawer(BuildContext context) {
  return Drawer(
      child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Dacit an audio training app for cochlear implant users',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
      ),
      _tile(AppLocalizations.of(context)!.recordAudio, "Record new audio",
          "record", Icons.record_voice_over, context),
      _tile(AppLocalizations.of(context)!.minimalPairs, "Identify single words",
          "minpairs", Icons.audiotrack, context),
      _tile(AppLocalizations.of(context)!.speakerDisambiguation,
          "Identify speakers", "speakerdis", Icons.audiotrack, context),
      _tile(AppLocalizations.of(context)!.settings, "", "settings",
          Icons.settings, context),
      _tile(AppLocalizations.of(context)!.about, "Additional information",
          "about", Icons.info, context),
    ],
  ));
}

ListTile _tile(String title, String subtitle, String path, IconData icon,
    BuildContext context) {
  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue,
    ),
    onTap: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/' + path);
    },
  );
}

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({required this.onStop});

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  //Timer? _timer;
  //Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    //  _timer?.cancel();
    //  _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {}
}
