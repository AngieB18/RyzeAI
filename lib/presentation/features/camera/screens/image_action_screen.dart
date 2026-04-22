import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/features/camera/screens/style_inspiration_screen.dart';

class ImageActionScreen extends StatelessWidget {
  final File image;

  const ImageActionScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    // Navegamos automáticamente a StyleInspirationScreen al abrir esta pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StyleInspirationScreen(image: image),
        ),
      );
    });

    // Pantalla de transición mientras redirige
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}