import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import '../widgets/action_option_card.dart';
import '../widgets/prompt_input_sheet.dart';

class ImageActionScreen extends StatelessWidget {
  final File image;

  const ImageActionScreen({super.key, required this.image});

  void _showPromptSheet(BuildContext context, String title, String hint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // importante para que suba con el teclado
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PromptInputSheet(
        title: title,
        hint: hint,
        onGenerate: (prompt) {
          // TODO: aquí llamas a tu servicio de IA con `image` y `prompt`
          debugPrint('Imagen: ${image.path}');
          debugPrint('Prompt: $prompt');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Generando: $prompt'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '¿Qué quieres hacer?',
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto tomada
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Elige una opción',
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Opción 1: Diseñar desde cero
            ActionOptionCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Diseñar desde cero',
              description: 'Dime qué muebles u objetos quieres agregar',
              onTap: () => _showPromptSheet(
                context,
                'Diseñar desde cero',
                'Ej: quiero un escritorio moderno, monitor, plantas y buena iluminación',
              ),
            ),
            const SizedBox(height: 12),

            // Opción 2: Reorganizar espacio
            ActionOptionCard(
              icon: Icons.space_dashboard_rounded,
              title: 'Reorganizar espacio',
              description: 'Ya tienes cosas pero quieres mejor distribución',
              onTap: () => _showPromptSheet(
                context,
                'Reorganizar espacio',
                'Ej: quiero que se vea más amplio y con mejor flujo de trabajo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}