import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart' show themeProvider;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _dragValue = 0.0;
  final double _sliderWidth = 300.0;
  final double _thumbSize = 60.0;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    // ListenableBuilder: se reconstruye cuando el tema cambia (ej. usuario regresa y tiene dark mode)
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        final isDark = themeProvider.isDark;
        final bgColor = isDark ? AppColors.darkBackground : Colors.white;
        final trackColor = isDark ? AppColors.darkSurface : Colors.grey.shade200;
        final trackTextColor =
            isDark ? AppColors.darkTextSecondary : Colors.grey.shade600;

        return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              // ── Círculos decorativos esquinas ─────────────
              Positioned(
                top: -80,
                right: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -70,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // ── Logo central ──────────────────────────────
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    // Marco blanco solo en modo oscuro para que el logo se vea bien
                    color: isDark
                        ? Colors.white.withOpacity(0.95)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
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
                      "assets/LogoRyzeAI.png",
                      width: isDark ? 130 : 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // ── Slider "Deslízame" ────────────────────────
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildSlider(l, trackColor, trackTextColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlider(S l, Color trackColor, Color trackTextColor) {
    final progress = _dragValue / (_sliderWidth - _thumbSize);

    return Container(
      width: _sliderWidth,
      height: _thumbSize,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(_thumbSize / 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Texto de fondo que se desvanece al deslizar
          Opacity(
            opacity: (1 - progress).clamp(0.0, 1.0),
            child: Text(
              l.slide_me ?? "Slide to start",
              style: TextStyle(
                color: trackTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),

          // Thumb deslizable
          Positioned(
            left: _dragValue,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragValue += details.delta.dx;
                  if (_dragValue < 0) _dragValue = 0;
                  if (_dragValue > _sliderWidth - _thumbSize) {
                    _dragValue = _sliderWidth - _thumbSize;
                  }
                });
              },
              onHorizontalDragEnd: (_) {
                if (_dragValue >= _sliderWidth - _thumbSize) {
                  Navigator.pushReplacementNamed(context, "/welcome");
                } else {
                  setState(() => _dragValue = 0.0);
                }
              },
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
