import 'package:dacit/settings/ci_selection_dropdown%20copy.dart';
import 'package:dacit/settings/language_selection_dropdown.dart';
import 'package:dacit/settings/role_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  static const String _title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
          body: Center(
              child: Column(
            children: <Widget>[
              Text('Language'),
              LanguageSelectionDropdown(),
              Text("Cochlear Implantat Hersteller"),
              CISelectionDropdown(),
              Text("Rolle"),
              RoleSelectionDropdown(),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Gebe die ID deiner Bezugsperson ein',
                ),
              ),
            ],
          )),
        ));
  }
}
