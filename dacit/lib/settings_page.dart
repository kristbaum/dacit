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
              Text("Ihre App-ID: 1293084076"),
              Text("Rolle"),
              RoleSelectionDropdown(),
              // TODO: Don't show the other sections until selected
              // When SprecherIn
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Geben Sie die ID Ihrer Bezugsperson ein',
                  ),
                ),
              ),


              Text('Was ist Ihre Muttersprache? '),
              LanguageSelectionDropdown(),

              
              
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Welchen Dialekt sprechen Sie?',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'In welchem Jahr sind Sie geboren?',
                    //Todo: Limit to 4 Int
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
