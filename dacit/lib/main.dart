import 'package:dacit/pages/home_page.dart';
import 'package:dacit/pages/login_page.dart';
import 'package:dacit/pages/signup_page.dart';
import 'package:dacit/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:dacit/minimal_pairs_page.dart';
import 'package:dacit/pages/settings_page.dart';
import 'package:dacit/pages/speaker_dis_page.dart';
import 'package:dacit/pages/about_page.dart';
import 'package:dacit/pages/record_page.dart';
import 'package:logging/logging.dart';

final log = Logger('DacitLogger');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const Dacit());
}

class Dacit extends StatelessWidget {
  const Dacit({Key? key}) : super(key: key);

  Future<AppUser> getLogginData() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      log.warning("Token not found");
      //Redirect to login
      throw "No token in storage";
    } else {
      //Test if token is still active
      log.warning("Testing if token is still active");
      user.token = token;
      return user;
    }
  }

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
        primaryColor: Colors.blueGrey,

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
      home: FutureBuilder(
          future: getLogginData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const LoginPage();
                } else {
                  return const HomePage();
                }
              default:
                return Container(); // error view
            }
          }),
      //home: isLoggedIn ? const HomePage(title: 'Dacit') : const LoginPage(),
      routes: {
//        '/minpairs': (context) => const MinimalPairs(),
        '/record': (context) => const RecordPage(),
        '/settings': (context) => const SettingsPage(),
        '/speakerdis': (context) => const SpeakerDisPage(),
        '/about': (context) => const AboutPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
