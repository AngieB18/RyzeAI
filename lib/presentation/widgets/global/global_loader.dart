import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class GlobalLoader {
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (!_isShowing) {
      _isShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CustomLoader(),
      );
    }
  }

  static void hide(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: AnimatedLoader(),
      ),
    );
  }
}

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1150),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Primer círculo - load-one
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.7854) // 45° en radianes
              ..rotateY(-0.7854), // -45° en radianes
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0, 1, curve: Curves.linear),
                ),
              ),
              child: CustomPaint(
                size: const Size(100, 100),
                painter: LoaderPainter(index: 0),
              ),
            ),
          ),
          // Segundo círculo - load-two
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.7854) // 45° en radianes
              ..rotateY(0.7854), // 45° en radianes
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0, 1, curve: Curves.linear),
                ),
              ),
              child: CustomPaint(
                size: const Size(100, 100),
                painter: LoaderPainter(index: 1),
              ),
            ),
          ),
          // Tercer círculo - load-three
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-1.0472), // -60° en radianes
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0, 1, curve: Curves.linear),
                ),
              ),
              child: CustomPaint(
                size: const Size(100, 100),
                painter: LoaderPainter(index: 2),
              ),
            ),
          ),
          // Texto de carga
          const Positioned(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoaderPainter extends CustomPainter {
  final int index;

  LoaderPainter({required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    switch (index) {
      case 0: // load-one - border-bottom
        paint.color = AppColors.primary; // Usar color principal
        canvas.drawArc(
          Rect.fromLTWH(0, 0, size.width, size.height),
          0,
          3.14159, // π radianes = 180°
          false,
          paint,
        );
        break;
      case 1: // load-two - border-right
        paint.color = AppColors.passwordStrong; // Verde para contraste
        canvas.drawArc(
          Rect.fromLTWH(0, 0, size.width, size.height),
          -1.5708, // -π/2 radianes = -90°
          1.5708, // π/2 radianes = 90°
          false,
          paint,
        );
        break;
      case 2: // load-three - border-top
        paint.color = AppColors.passwordMedium; // Naranja para contraste
        canvas.drawArc(
          Rect.fromLTWH(0, 0, size.width, size.height),
          3.14159, // π radianes = 180°
          3.14159, // π radianes = 180°
          false,
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}