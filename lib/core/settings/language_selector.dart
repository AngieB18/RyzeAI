import 'package:flutter/material.dart';
import '../../main.dart';
import '../../generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? selected;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  // Carga idioma guardado en Supabase
  Future<void> _loadCurrentLanguage() async {
    final uid = _supabase.auth.currentUser?.id;

    if (uid != null) {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', uid)
          .single();

      if (response != null) {
        final lang = (response as Map<String, dynamic>)['language'];

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

        final uid = _supabase.auth.currentUser?.id;

        if (uid != null) {
          await _supabase
              .from('users')
              .update({
            'language': value,
          }).eq('id', uid);
        }
      },
    );
  }
}