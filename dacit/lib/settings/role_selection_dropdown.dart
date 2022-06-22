import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoleSelectionDropdown extends StatefulWidget {
  const RoleSelectionDropdown({Key? key}) : super(key: key);

  @override
  State<RoleSelectionDropdown> createState() => _RoleSelectionDropdownState();
}

class _RoleSelectionDropdownState extends State<RoleSelectionDropdown> {
  String dropdownValue = 'Parent';

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
        'Parent',
        'Sibling',
        'Friend',
        'Grandparent',
        'Therapist'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

