// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';
 import '../../main.dart'; 

class AppColors {
  // ── Color principal (no cambia con el tema) ──
  static const Color primary = Color(0xFFBF6D3A);

  // ── Colores de contraseña (no cambian) ──
  static const Color passwordWeak = Color(0xFFD94F3D);
  static const Color passwordMedium = Color(0xFFE8A020);
  static const Color passwordStrong = Color(0xFF4C9B6E);

  // ── Tema OSCURO ──
  static const Color darkBackground = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF2C2C2E);
  static const Color darkInputBorder = Color(0xFF3A3A3C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkHeader = Color(0xFF2A1F1A);

  // ── Tema CLARO ──
  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInputBorder = Color(0xFFD1D1D6);
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF6C6C70);
  static const Color lightHeader = Color(0xFFFFEDE3);
  // Importa el main para acceder al themeProvider global

  static Color background(BuildContext context) =>
      themeProvider.isDark ? darkBackground : lightBackground;

  static Color surface(BuildContext context) =>
      themeProvider.isDark ? darkSurface : lightSurface;

  static Color inputBorder(BuildContext context) =>
      themeProvider.isDark ? darkInputBorder : lightInputBorder;

  static Color textPrimary(BuildContext context) =>
      themeProvider.isDark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      themeProvider.isDark ? darkTextSecondary : lightTextSecondary;

  static Color header(BuildContext context) =>
      themeProvider.isDark ? darkHeader : lightHeader;

}