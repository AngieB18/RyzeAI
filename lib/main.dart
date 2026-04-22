import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/features/auth/screens/splash_page.dart';
import 'presentation/features/auth/screens/welcome_page.dart';
import 'presentation/features/auth/screens/login_page.dart';
import 'presentation/features/auth/screens/register_page.dart';
import 'presentation/features/auth/screens/new_password_page.dart'; // Tu pantalla
import 'presentation/features/home/screens/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://xejcfclltcnigufcsqvb.supabase.co',
    anonKey: 'sb_publishable_tbu_TdCUp-6Ft6wTgEfxDQ_5Yxdesfw', 
  );

  await themeProvider.loadTheme();

  runApp(const MyApp());
}

final themeProvider = ThemeProvider();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  // Usamos una GlobalKey para navegar sin necesidad de context si es necesario
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    
    // Configuramos el escuchador de Supabase para detectar el link de recuperación
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        // Cuando detecta el evento, navega a tu pantalla de Nueva Contraseña
        navigatorKey.currentState?.pushReplacementNamed('/new-password');
      }
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return MaterialApp(
          navigatorKey: navigatorKey, // Asignamos la llave de navegación
          debugShowCheckedModeBanner: false,
          locale: _locale,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: "/",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "/":
                return _fadeRoute(const SplashPage());
              case "/welcome":
                return _fadeRoute(const WelcomePage());
              case "/login":
                return _fadeRoute(const LoginPage());
              case "/register":
                return _fadeRoute(const RegisterPage());
              case "/home":
                return _fadeRoute(const HomePage());
              case "/new-password": // <-- Ruta para tu nueva pantalla
                return _fadeRoute(const NewPasswordPage());
              default:
                return _fadeRoute(const SplashPage());
            }
          },
        );
      },
    );
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}