import 'package:dacit/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:dacit/minimal_pairs_page.dart';
import 'package:dacit/pages/settings_page.dart';
import 'package:dacit/pages/speaker_dis_page.dart';
import 'package:dacit/pages/about_page.dart';
import 'package:dacit/pages/record_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

final log = Logger('DacitLogger');

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const Dacit());
}

class Dacit extends StatelessWidget {
  const Dacit({Key? key}) : super(key: key);

  final _storage = const FlutterSecureStorage();

  Future<void> _readToken() async {
    final token = await _storage.read(key: "token");
    if (token == null) {
      log.warning("Token not found");
      //Redirect to login
    } else {
      //Test if token is still active
      log.warning("Testing if token is still active");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _readToken();
    return MaterialApp(
      title: 'Dacit',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.green,
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey,

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
      home: const HomePage(title: 'Dacit'),
      routes: {
//        '/minpairs': (context) => const MinimalPairs(),
        '/record': (context) => const RecordPage(),
        '/settings': (context) => const Settings(),
        '/speakerdis': (context) => const SpeakerDis(),
        '/about': (context) => const About()
      },
      // home: Main(),
    );
  }
}
