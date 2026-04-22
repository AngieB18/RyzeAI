import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../main.dart' show themeProvider;
import '../widgets/welcome_widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder garantiza que la pantalla se reconstruya
    // cuando el usuario cambia el tema desde su perfil.
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return const Scaffold(
          backgroundColor: AppColors.primarySoft,
          body: Column(
            children: [
              // Parte superior: fondo blanco/oscuro con logo
              WelcomeHeaderNew(),
              // Parte inferior: naranja suave con título y botones
              WelcomeContentNew(),
            ],
          ),
        );
      },
    );
  }
}
