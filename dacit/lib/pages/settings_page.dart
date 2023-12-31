import 'package:dacit/services/settings/language_selection_dropdown.dart';
import 'package:dacit/services/settings/role_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
      body: Center(
          child: Column(
        children: <Widget>[
          Text("${AppLocalizations.of(context).appID}1293084076"),
          const Text("Rolle"),
          const RoleSelectionDropdown(),
          // TODO: Don't show the other sections until selected
          // When SprecherIn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Geben Sie die ID Ihrer Bezugsperson ein',
              ),
            ),
          ),

          Text(AppLocalizations.of(context).whichmotherlang),
          const LanguageSelectionDropdown(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: TextFormField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: AppLocalizations.of(context).whichdialect,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: TextFormField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: AppLocalizations.of(context).whichyear,
                //TODO: Limit to 4 Int
              ),
            ),
          ),
        ],
      )),
    );
  }
}
