import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class RegisterHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onLogin;

  const RegisterHeader({
    super.key,
    required this.onBack,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila: Back + "Sign In"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black, size: 22),
                ),
                GestureDetector(
                  onTap: onLogin,
                  child: Text(
                    l.login_tab ?? "Sign In",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              l.signup_tab ?? "Sign Up",
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.joinRyzeAI,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(0.65),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
