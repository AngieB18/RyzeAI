import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String selected = "EN";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(value: "EN", child: Text("English")),
        DropdownMenuItem(value: "ES", child: Text("Español")),
      ],
      onChanged: (value) {
        setState(() {
          selected = value!;
        });
      },
    );
  }
}