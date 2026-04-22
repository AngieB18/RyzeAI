import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart' show themeProvider;
import '../../../../core/constants/app_assets.dart';
import 'auth_custom_widgets.dart';



class WelcomeHeaderNew extends StatelessWidget {
  const WelcomeHeaderNew({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDark;
    // Claro → blanco, Oscuro → fondo oscuro
    final headerBg = isDark ? AppColors.darkBackground : Colors.white;
    final lineColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

    return ClipPath(
      clipper: HeaderWaveClipper(),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.45,
        color: headerBg,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: TopographyPainter(lineColor: lineColor),
              ),
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  // Marco blanco solo en modo oscuro
                  color: isDark
                      ? Colors.white.withOpacity(0.95)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.12),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ]
                      : null,
                ),
                padding: isDark ? const EdgeInsets.all(24) : EdgeInsets.zero,
                child: Hero(
                  tag: 'auth_logo',
                  child: Image.asset(
                    AppAssets.logo,
                    width: isDark ? 130 : 180,
                    fit: BoxFit.contain,
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

class WelcomeContentNew extends StatelessWidget {
  const WelcomeContentNew({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.55,
      decoration: const BoxDecoration(
        color: AppColors.primarySoft,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.welcome_title ?? "Welcome",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.welcome_subtitle ??
                "Get inspired and design your ideal space in 3D",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  label: l.login ?? "Sign In",
                  isPrimary: true,
                  onPressed: () => Navigator.pushNamed(context, "/login"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildButton(
                  label: l.signup_tab ?? "Sign Up",
                  isPrimary: false,
                  onPressed: () => Navigator.pushNamed(context, "/register"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.black : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
