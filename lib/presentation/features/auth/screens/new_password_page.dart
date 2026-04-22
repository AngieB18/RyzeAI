import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/generated/l10n.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _updatePassword() async {
    final localizations = S.of(context);
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validaciones
    if (password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(localizations.passwordRequired);
      return;
    }

    if (password != confirmPassword) {
      _showMessage(localizations.passwordsDoNotMatch);
      return;
    }

    if (password.length < 6) {
      _showMessage(localizations.passwordTooShort);
      return;
    }

    setState(() => _loading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );

      _showMessage(localizations.passwordUpdated, success: true);

      // Redirigir al login o home después de actualizar
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/login');
      });

    } catch (e) {
      _showMessage(localizations.errorUpdatingPassword);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMessage(String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        title: Text(
          success ? "✔" : "Error",
          style: TextStyle(
            color: success ? Colors.green : AppColors.textPrimary(context),
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: AppColors.textPrimary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("OK", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: onToggleVisibility,
      ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.newPassword,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              localizations.enterNewPassword,
              style: TextStyle(
                color: AppColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: 30),
            // Nueva contraseña
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: TextStyle(color: AppColors.textPrimary(context)),
              decoration: _inputDecoration(
                hint: localizations.password,
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            const SizedBox(height: 20),
            // Confirmar contraseña
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              style: TextStyle(color: AppColors.textPrimary(context)),
              decoration: _inputDecoration(
                hint: localizations.confirmPassword,
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
            ),
            const SizedBox(height: 30),
            // Botón
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _loading ? null : _updatePassword,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        localizations.updatePassword,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}