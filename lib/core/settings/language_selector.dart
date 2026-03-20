import 'package:flutter/material.dart';
import '../../main.dart';
import '../../generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? selected;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  // Carga idioma guardado en Firebase
  Future<void> _loadCurrentLanguage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final lang = doc.data()!['language'];

        setState(() {
          selected = lang;
        });

        // Aplicar idioma al iniciar
        MyApp.setLocale(context, Locale(lang));
      }
    }
  }

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
        DropdownMenuItem(value: "en", child: Text("English")),
        DropdownMenuItem(value: "es", child: Text("Español")),
      ],
      onChanged: (value) async {
        if (value == null) return;

        setState(() {
          selected = value;
        });

        MyApp.setLocale(context, Locale(value));

        final uid = FirebaseAuth.instance.currentUser?.uid;

        if (uid != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({
            'language': value,
          });
        }
      },
    );
  }
}