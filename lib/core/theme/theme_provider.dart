// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  static ThemeProvider of(BuildContext context) {
    return context
        .findAncestorStateOfType<_ThemeProviderInheritedState>()!
        .widget
        .provider;
  }
}

// Widget que expone el provider al árbol
class ThemeProviderWidget extends StatefulWidget {
  final ThemeProvider provider;
  final Widget child;

  const ThemeProviderWidget({
    super.key,
    required this.provider,
    required this.child,
  });

  @override
  State<ThemeProviderWidget> createState() => _ThemeProviderInheritedState();
}

class _ThemeProviderInheritedState extends State<ThemeProviderWidget> {
  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_onThemeChanged);
  }

  void _onThemeChanged() => setState(() {});

  @override
  void dispose() {
    widget.provider.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}