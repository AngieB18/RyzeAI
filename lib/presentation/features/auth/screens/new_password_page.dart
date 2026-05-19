import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart' show MyApp, themeProvider;
import '../../../../core/services/user_service.dart';
import '../widgets/auth_custom_widgets.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _sessionReady = false;

  @override
  void initState() {
    super.initState();
    // 1. Forzamos modo claro al entrar al restablecimiento de contraseña por defecto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider.setTheme(false); // false = modo claro
    });
    _initializeRecovery();
  }

  Future<void> _loadUserPreferences() async {
    try {
      final userData = await UserService.getCurrentUserData();
      if (userData != null) {
        // Cargar idioma configurado en perfil
        final lang = userData['language'] ?? 'es';
        if (mounted) {
          MyApp.setLocale(context, Locale(lang));
        }
        // Cargar tema configurado en perfil
        if (userData['theme'] != null) {
          final isDark = userData['theme'] == 'dark';
          await themeProvider.setTheme(isDark);
        }
      }
    } catch (e) {
      print("Error al cargar las preferencias del perfil: $e");
    }
  }

  Future<void> _initializeRecovery() async {
    // Damos tiempo para que el SDK de Supabase procese el código de fondo en la web
    await Future.delayed(const Duration(milliseconds: 800));

    // 1. Verificamos si supabase_flutter ya lo manejó en segundo plano
    if (Supabase.instance.client.auth.currentSession != null) {
      if (mounted) {
        setState(() => _sessionReady = true);
        _loadUserPreferences();
      }
      return;
    }

    // 2. Si no hay sesión, intentamos canjear el código manualmente para atrapar el error exacto
    try {
      final uri = Uri.base;
      final code = uri.queryParameters['code'];
      
      if (code != null) {
        await Supabase.instance.client.auth.exchangeCodeForSession(code);
        if (mounted) {
          setState(() => _sessionReady = true);
          _loadUserPreferences();
        }
      }
    } catch (e) {
      print("Error detallado al canjear código: $e");
      if (mounted) {
        if (e.toString().toLowerCase().contains('code verifier')) {
          ErrorDialog.show(context, 'Error de seguridad (PKCE): Estás abriendo el link en un dispositivo/navegador diferente al que solicitó el cambio.');
        } else {
          ErrorDialog.show(context, 'Error al obtener sesión: $e');
        }
      }
    }

    // Escuchamos por si la sesión se resuelve un instante después
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted && data.session != null) {
        setState(() {
          _sessionReady = true;
        });
        _loadUserPreferences();
      }
    });
  }

  Future<void> _updatePassword() async {
    final password = _passwordController.text.trim();
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    if (password.isEmpty) {
      ErrorDialog.show(
        context, 
        isEs ? 'Ingresa una contraseña' : 'Please enter a password'
      );
      return;
    }

    if (password.length < 6) {
      ErrorDialog.show(
        context, 
        isEs ? 'La contraseña debe tener mínimo 6 caracteres' : 'Password must be at least 6 characters'
      );
      return;
    }

    if (!_sessionReady) {
      ErrorDialog.show(
        context, 
        isEs ? 'Sesión inválida' : 'Invalid session'
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEs 
                ? 'Contraseña actualizada correctamente' 
                : 'Password updated successfully'
          ),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    } catch (e) {
      print(e);
      if (mounted) {
        ErrorDialog.show(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    return AuthScreenLayout(
      title: l.newPassword,
      subtitle: isEs 
          ? "Ingresa tu nueva contraseña para acceder." 
          : "Enter your new password to access your account.",
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthInputField(
            controller: _passwordController,
            label: l.password,
            hintText: isEs ? "Mínimo 6 caracteres" : "Minimum 6 characters",
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 32),
          AuthPrimaryButton(
            label: l.updatePassword,
            isLoading: _loading,
            onPressed: _updatePassword,
          ),
        ],
      ),
    );
  }
}