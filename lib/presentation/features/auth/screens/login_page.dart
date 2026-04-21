import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/global/global_loader.dart';
import '../widgets/widgets_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  Future<void> _iniciarSesion() async {
    // "translations" en lugar de "s" → más claro para cualquier desarrollador
    final translations = S.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarError(translations.emptyFieldsError);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _mostrarError(translations.invalidEmail);
      return;
    }

    try {
      GlobalLoader.show(context);

      final supabase = Supabase.instance.client;

      // LOGIN CON SUPABASE
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      GlobalLoader.hide(context);

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on AuthException catch (e) {
      GlobalLoader.hide(context);

      String mensajeFriendly;

      switch (e.message.toLowerCase()) {
        case 'invalid login credentials':
          mensajeFriendly = translations.loginError;
          break;
        case 'email not confirmed':
          mensajeFriendly = "Debes confirmar tu correo";
          break;
        default:
          mensajeFriendly = translations.registerError;
      }

      _mostrarError(mensajeFriendly);
    } catch (e) {
      GlobalLoader.hide(context);
      _mostrarError(translations.registerError);
    }
  }

  void _mostrarError(String mensaje) {
    ErrorDialog.show(context, mensaje);
  }

  @override
  Widget build(BuildContext context) {
    // "translations"  sistema de idiomas
    final translations = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              // Botón regresar
              const LoginBackButton(),

              const SizedBox(height: 20),

              // Logo
              const LoginLogo(),

              const SizedBox(height: 30),

              // Título y subtítulo
              LoginHeader(
                title: translations.welcomeBack,
                subtitle: translations.joinRyzeAI,
              ),

              const SizedBox(height: 30),

              // Tarjeta del formulario
              LoginFormCard(
                child: Column(
                  children: [

                    // Campo email
                    LoginTextField(
                      controller: _emailController,
                      hintText: translations.enterEmail,
                      prefixIcon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    // Campo contraseña
                    LoginTextField(
                      controller: _passwordController,
                      hintText: translations.enterYourPassword,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ❓ ¿Olvidaste tu contraseña?
                    LoginForgotPasswordButton(
                      label: translations.forgotPassword,
                    ),

                    const SizedBox(height: 10),

                    // Botón iniciar sesión
                    LoginSubmitButton(
                      label: translations.login,
                      onPressed: _iniciarSesion,
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}