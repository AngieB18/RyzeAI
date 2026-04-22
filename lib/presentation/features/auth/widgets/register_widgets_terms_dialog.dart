import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../main.dart' show themeProvider;

class RegisterTermsDialog extends StatelessWidget {
  final bool isTerms;
  final VoidCallback onAccept;

  const RegisterTermsDialog({
    super.key,
    required this.isTerms,
    required this.onAccept,
  });

  static void show(BuildContext context, {required bool isTerms, required VoidCallback onAccept}) {
    showDialog(
      context: context,
      builder: (_) => RegisterTermsDialog(isTerms: isTerms, onAccept: onAccept),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final isDark = themeProvider.isDark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isTerms
                        ? Icons.description_outlined
                        : Icons.privacy_tip_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isTerms ? l.termsOfService : l.privacyPolicy,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                isTerms ? l.termsContent : l.privacyContent,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),
          ),
          // Accept Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                onPressed: () {
                  onAccept();
                  Navigator.pop(context);
                },
                child: Text(
                  l.acceptAndClose,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
