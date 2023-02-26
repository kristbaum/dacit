import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget drawer(BuildContext context) {
  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(AppLocalizations.of(context).dacitDescription,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                color: Colors.white)),
      ),
      _tile(
          AppLocalizations.of(context).recordAudio,
          AppLocalizations.of(context).recordAudioDesc,
          "record",
          Icons.record_voice_over,
          context),
      _tile(
          AppLocalizations.of(context).minimalPairs,
          AppLocalizations.of(context).identWord,
          "minpairs",
          Icons.audiotrack,
          context),
      _tile(
          AppLocalizations.of(context).speakerDisambiguation,
          AppLocalizations.of(context).identSpeaker,
          "speakerdis",
          Icons.audiotrack,
          context),
      const Divider(
        thickness: 10,
      ),
      _tile(AppLocalizations.of(context).settings, "", "settings",
          Icons.settings, context),
      _tile(AppLocalizations.of(context).about,
          AppLocalizations.of(context).additInfo, "about", Icons.info, context),
    ],
  ));
}

ListTile _tile(String title, String subtitle, String path, IconData icon,
    BuildContext context) {
  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 25,
        )),
    subtitle: Text(subtitle,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
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
