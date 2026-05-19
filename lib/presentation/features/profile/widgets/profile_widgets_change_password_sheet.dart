import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';

class ProfileWidgetsChangePasswordSheet extends StatefulWidget {
  const ProfileWidgetsChangePasswordSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ProfileWidgetsChangePasswordSheet(),
    );
  }

  @override
  State<ProfileWidgetsChangePasswordSheet> createState() => _ProfileWidgetsChangePasswordSheetState();
}

class _ProfileWidgetsChangePasswordSheetState extends State<ProfileWidgetsChangePasswordSheet> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final l = S.of(context);
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ErrorDialog.show(
        context, 
        isEs ? 'Por favor completa todos los campos.' : 'Please fill all fields.'
      );
      return;
    }

    if (newPassword.length < 6) {
      ErrorDialog.show(
        context, 
        isEs ? 'La contraseña debe tener al menos 6 caracteres.' : 'Password must be at least 6 characters.'
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ErrorDialog.show(
        context, 
        isEs ? 'Las contraseñas no coinciden.' : 'Passwords do not match.'
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEs 
                  ? 'Contraseña actualizada con éxito.' 
                  : 'Password updated successfully.'
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSheetTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBorder(context).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder(context).withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: AppColors.textPrimary(context), fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary(context).withOpacity(0.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textSecondary(context).withOpacity(0.6),
              size: 20,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder(context).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isEs ? 'Cambiar Contraseña' : 'Change Password',
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEs 
                  ? 'Ingresa tu nueva contraseña para actualizarla.'
                  : 'Enter your new password below to update it.',
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isEs ? 'Nueva contraseña' : 'New password', 
              style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w500)
            ),
            const SizedBox(height: 6),
            _buildSheetTextField(
              context: context,
              controller: _newPasswordController,
              hint: isEs ? 'Escribe tu nueva contraseña' : 'Enter new password',
              obscureText: _obscureNew,
              onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 16),
            Text(
              isEs ? 'Confirmar contraseña' : 'Confirm password', 
              style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w500)
            ),
            const SizedBox(height: 6),
            _buildSheetTextField(
              context: context,
              controller: _confirmPasswordController,
              hint: isEs ? 'Confirma tu nueva contraseña' : 'Confirm new password',
              obscureText: _obscureConfirm,
              onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: _isLoading ? null : _updatePassword,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        isEs ? 'Actualizar Contraseña' : 'Update Password', 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
