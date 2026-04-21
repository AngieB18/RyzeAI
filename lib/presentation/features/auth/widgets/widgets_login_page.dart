import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/features/auth/screens/recover_password_page.dart';
import '../../../../core/constants/app_assets.dart';

class LoginBackButton extends StatelessWidget {
  const LoginBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Logo de RyzeAI
// ─────────────────────────────────────────
class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      height: 90,
    );
  }
}

// ─────────────────────────────────────────
// Título y subtítulo de bienvenida
// ─────────────────────────────────────────
class LoginHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textSecondary(context),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Campo de texto reutilizable (email / password)
// ─────────────────────────────────────────
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: AppColors.surface(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// ─────────────────────────────────────────
// Enlace "¿Olvidaste tu contraseña?"
// ─────────────────────────────────────────
class LoginForgotPasswordButton extends StatelessWidget {
  final String label;

  const LoginForgotPasswordButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RecoverPasswordPage(),
            ),
          );
        },
        child: Text(
          label,
          style: TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Botón principal "Iniciar sesión"
// ─────────────────────────────────────────
class LoginSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const LoginSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tarjeta contenedora del formulario
// ─────────────────────────────────────────
class LoginFormCard extends StatelessWidget {
  final Widget child;

  const LoginFormCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.05),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}