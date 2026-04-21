import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final _supabase = Supabase.instance.client;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  // Cargar tema desde Supabase
  Future<void> loadTheme() async {
    final uid = _supabase.auth.currentUser?.id;

    if (uid != null) {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', uid)
          .single();

      if (response != null) {
        final data = response as Map<String, dynamic>;
        final theme = data['theme'] ?? 'light';

        _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    }
  }

  // Cambiar y guardar tema
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();

    final uid = _supabase.auth.currentUser?.id;

    if (uid != null) {
      await _supabase
          .from('users')
          .update({
        'theme': _themeMode == ThemeMode.dark ? 'dark' : 'light',
      }).eq('id', uid);
    }
  }

  // Cambiar tema directamente
  Future<void> setTheme(bool isDarkMode) async {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();

    final uid = _supabase.auth.currentUser?.id;

    if (uid != null) {
      await _supabase
          .from('users')
          .update({
        'theme': isDarkMode ? 'dark' : 'light',
      }).eq('id', uid);
    }
  }
}