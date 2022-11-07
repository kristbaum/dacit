import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dacit/minimal_pairs_page.dart';
import 'package:dacit/record_audio.dart';
import 'package:dacit/settings_page.dart';
import 'package:dacit/speaker_dis_page.dart';
import 'package:dacit/about_page.dart';

void main() {
  runApp(const Dacit());
}

class Dacit extends StatelessWidget {
  const Dacit({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dacit',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.green,
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.5,
              fontSizeDelta: 5.0,
            ),
        //fontSizeFactor: 1.1
        //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //bodyText1: TextStyle(fontSize: 34.0, fontFamily: 'Hind'),
      ),
      home: const DacitPage(title: 'Dacit'),
      routes: {
        '/minpairs': (context) => const MinimalPairs(),
        '/record': (context) => const RecordPage(),
        '/settings': (context) => const Settings(),
        '/speakerdis': (context) => const SpeakerDis(),
        '/about': (context) => const About()
      },
      // home: Main(),
    );
  }
}

class DacitPage extends StatefulWidget {
  const DacitPage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _DacitPageState createState() => _DacitPageState();
}

class _DacitPageState extends State<DacitPage> {
  void _incrementCounter() {
    setState(() {});
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).welcome,
                style:
                    const TextStyle(fontSize: 30, fontStyle: FontStyle.normal),
              )
            ],
          ),
        ));
  }
}

Widget drawer(BuildContext context) {
  return Drawer(
      child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        // decoration: BoxDecoration(
        //   color: Colors.blue,
        // ),
        child: Text(
          'Dacit an audio training app for cochlear implant users',
          // style: const TextStyle(
          //   fontWeight: FontWeight.w500,
          //   fontSize: 20,
          // )
        ),
      ),
      _tile(
          AppLocalizations.of(context).recordAudio,
          AppLocalizations.of(context).recordAudioDesc,
          "record",
          Icons.record_voice_over,
          context),
      _tile(AppLocalizations.of(context).minimalPairs, "Identify single words",
          "minpairs", Icons.audiotrack, context),
      _tile(AppLocalizations.of(context).speakerDisambiguation,
          "Identify speakers", "speakerdis", Icons.audiotrack, context),
      _tile(AppLocalizations.of(context).settings, "", "settings",
          Icons.settings, context),
      _tile(AppLocalizations.of(context).about, "Additional information",
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
      Navigator.pushNamed(context, '/$path');
    },
  );
}
