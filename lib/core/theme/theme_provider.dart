import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  // Cargar tema desde Firebase
  Future<void> loadTheme() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
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

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'theme': _themeMode == ThemeMode.dark ? 'dark' : 'light',
      });
    }
  }

  // Cambiar tema directamente 
  Future<void> setTheme(bool isDarkMode) async {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'theme': isDarkMode ? 'dark' : 'light',
      });
    }
  }
}