import 'package:flutter/material.dart';

class DialectSelectionDropdown extends StatefulWidget {
  const DialectSelectionDropdown({Key? key}) : super(key: key);

  @override
  State<DialectSelectionDropdown> createState() => _DialectSelectionDropdownState();
}

class _DialectSelectionDropdownState extends State<DialectSelectionDropdown> {
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
        'Niederfrä',
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
