import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../generated/l10n.dart';
import '../widgets/auth_custom_widgets.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendRecoveryLink() async {
    final email = _emailController.text.trim();
    final l = S.of(context);

    if (email.isEmpty) {
      ErrorDialog.show(context, l.emptyFieldsError);
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ErrorDialog.show(context, l.invalidEmail);
      return;
    }

    setState(() => _isLoading = true);

    String? redirectTo;
    try {
      redirectTo = Uri.base.origin;
    } catch (_) {
      // Safe fallback for non-web environments
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enlace de recuperación enviado al correo.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('rate_limit') || errorStr.contains('after')) {
          ErrorDialog.show(context, 'Por seguridad, espera alrededor de 1 minuto antes de solicitar otro enlace.');
        } else {
          ErrorDialog.show(context, 'Error: ${e.toString()}');
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    
    return AuthScreenLayout(
      title: l.forgot_password_link ?? 'Recuperar Contraseña',
      subtitle: 'Ingresa tu correo electrónico para recibir un enlace de recuperación.',
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInputField(
            controller: _emailController,
            label: l.email,
            hintText: l.enterEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 32),
          AuthPrimaryButton(
            label: 'Enviar Enlace',
            isLoading: _isLoading,
            onPressed: _sendRecoveryLink,
          ),
        ],
      ),
    );
  }
}