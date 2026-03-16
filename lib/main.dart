import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'onboarding/pages/welcome_page.dart';
import 'auth/pages/login_page.dart';
import 'auth/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// pantalla inicial
      initialRoute: "/",

      /// rutas con transición personalizada
      onGenerateRoute: (settings) {
        switch (settings.name) {

          case "/":
            return _fadeRoute(const WelcomePage());

          case "/login":
            return _fadeRoute(const LoginPage());

          case "/register":
            return _fadeRoute(const RegisterPage());

          default:
            return _fadeRoute(const WelcomePage());
        }
      },
    );
  }
}

/// Transición fade entre pantallas
PageRouteBuilder _fadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}