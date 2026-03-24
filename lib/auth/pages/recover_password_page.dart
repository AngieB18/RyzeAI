import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import '../../generated/l10n.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  Future<void> _recoverPassword() async {
    final s = S.of(context);
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(s.invalidEmail);
      return;
    }

    setState(() => _loading = true);

    try {
      final locale = Localizations.localeOf(context).languageCode;

      FirebaseAuth.instance.setLanguageCode(locale);

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _showMessage(s.emailSentFull, success: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMessage(s.emailNotFound);
      } else if (e.code == 'invalid-email') {
        _showMessage(s.invalidEmail);
      } else {
        _showMessage(e.message ?? "Error");
      }
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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

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
              s.recoverPassword,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              s.enterYourEmail,
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
            const SizedBox(height: 30),

            /// EMAIL
            TextField(
              controller: _emailController,
              style: TextStyle(color: AppColors.textPrimary(context)),
              decoration: InputDecoration(
                hintText: s.email,
                hintStyle: TextStyle(color: AppColors.textSecondary(context)),
                filled: true,
                fillColor: AppColors.surface(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// BOTÓN
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: _loading ? null : _recoverPassword,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        s.sendEmail,
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
