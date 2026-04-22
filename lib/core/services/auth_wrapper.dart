import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/features/auth/screens/login_page.dart';
import '../../presentation/features/auth/screens/new_password_page.dart';
import '../../presentation/features/home/screens/home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  AuthChangeEvent? _lastEvent;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final event = snapshot.data?.event;
        final session = snapshot.data?.session;

        // Si el evento cambió a passwordRecovery, redirigir
        if (event == AuthChangeEvent.passwordRecovery && _lastEvent != event) {
          _lastEvent = event;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/new-password');
          });
        } else if (event != AuthChangeEvent.passwordRecovery) {
          _lastEvent = event;
        }

        if (session != null) {
          // Usuario autenticado, ir a home
          return const HomePage();
        } else {
          // Usuario no autenticado, ir a login
          return const LoginPage();
        }
      },
    );
  }
}