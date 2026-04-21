import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/constants/app_assets.dart';
class AuthTabBar extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onTabChanged;

  const AuthTabBar({
    super.key,
    required this.isLogin,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          
          Container(
            height: 2,
            color: AppColors.inputBorder(context).withOpacity(0.3),
          ),
          Row(
            children: [
              Expanded(
                child: _buildTab(
                  context,
                  title: l.login_tab ?? "Login",
                  isActive: isLogin,
                  onTap: isLogin ? null : onTabChanged,
                ),
              ),
              Expanded(
                child: _buildTab(
                  context,
                  title: l.signup_tab ?? "Signup",
                  isActive: !isLogin,
                  onTap: !isLogin ? null : onTabChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive 
                    ? AppColors.textPrimary(context) 
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: 80,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── AUTH INPUT FIELD ──────────────────────────────────────
/// A clean input field with the label above the border.
class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isPassword;
  final bool? obscureText;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.obscureText,
    this.onToggleVisibility,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context).withOpacity(0.8),
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          style: TextStyle(color: AppColors.textPrimary(context)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondary(context).withOpacity(0.5),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.inputBorder(context).withOpacity(0.5),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.passwordWeak),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.passwordWeak, width: 1.5),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (obscureText ?? true)
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textSecondary(context),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}

/// ── AUTH PRIMARY BUTTON ───────────────────────────────────
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

/// ── AUTH WAVY HEADER ──────────────────────────────────────
/// A premium header with a wavy orange background and 
/// topographical line pattern, featuring the logo.
class AuthWavyHeader extends StatelessWidget {
  const AuthWavyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.35;
    
    return Stack(
      children: [
        // Background Wavy Orange
        ClipPath(
          clipper: HeaderWaveClipper(),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF8C42), // Primary Orange
                  Color(0xFFFF5733), // Deep Orange
                ],
              ),
            ),
            child: CustomPaint(
              painter: TopographyPainter(),
            ),
          ),
        ),
        
        // Logo
        Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          child: Hero(
            tag: 'auth_logo',
            child: Image.asset(
              AppAssets.logo,
              height: 70,
              fit: BoxFit.contain,
              // Color filter is NOT used because user wants the real logo
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    
    var firstControlPoint = Offset(size.width * 0.25, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height - 70);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopographyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final random = math.Random(42); // Seed for consistency

    for (int i = 0; i < 8; i++) {
      final path = Path();
      final startY = i * 40.0;
      path.moveTo(-20, startY);
      
      for (double x = 0; x < size.width + 100; x += 50) {
        path.quadraticBezierTo(
          x + 25, 
          startY + (random.nextDouble() * 60 - 30), 
          x + 50, 
          startY + (random.nextDouble() * 20 - 10)
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
