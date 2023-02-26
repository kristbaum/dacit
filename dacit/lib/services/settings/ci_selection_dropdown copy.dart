import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CISelectionDropdown extends StatefulWidget {
  const CISelectionDropdown({Key? key}) : super(key: key);

  @override
  State<CISelectionDropdown> createState() => _CISelectionDropdownState();
}

class _CISelectionDropdownState extends State<CISelectionDropdown> {
  String dropdownValue = 'Cochlear Limited';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'Cochlear Limited',
        'Advanced Bionics',
        'MED-EL',
        'Neurelec',
        'Nurotron'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
