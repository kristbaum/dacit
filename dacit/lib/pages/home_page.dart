import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Dacit";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawer(context),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Image(image: AssetImage('icon.png')),
              Text(
                AppLocalizations.of(context).welcome,
                style:
                    const TextStyle(fontSize: 30, fontStyle: FontStyle.normal),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("0"),
                      Text(AppLocalizations.of(context).training),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("0"),
                      Text(AppLocalizations.of(context).recordings)
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
