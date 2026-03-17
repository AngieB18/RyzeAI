import 'package:flutter/material.dart';
import '../main.dart';
import '../generated/l10n.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      hint: Text(
        S.of(context).language, 
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      underline: const SizedBox(),
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      items: const [
        DropdownMenuItem(value: "EN", child: Text("English")),
        DropdownMenuItem(value: "ES", child: Text("Español")),
      ],
      onChanged: (value) {
        setState(() {
          selected = value!;
          // 🔹 Cambiar idioma dinámicamente
          if (value == "EN") {
            MyApp.setLocale(context, const Locale('en'));
          } else {
            MyApp.setLocale(context, const Locale('es'));
          }
        });
      },
    );
  }
}