import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart' show themeProvider;
import '../widgets/auth_custom_widgets.dart';
import 'recover_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final l = S.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ErrorDialog.show(context, l.emptyFieldsError);
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ErrorDialog.show(context, l.invalidEmail);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString('saved_email', email);
          await prefs.setString('saved_password', password);
        } else {
          await prefs.remove('saved_email');
          await prefs.remove('saved_password');
        }
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      final l2 = S.of(context);
      final msg = e.message.toLowerCase().contains('invalid login credentials')
          ? l2.loginError
          : l2.registerError;
      ErrorDialog.show(context, msg);
    } catch (_) {
      if (!mounted) return;
      ErrorDialog.show(context, S.of(context).registerError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return AuthScreenLayout(
      title: l.login_tab ?? "Sign In",
      subtitle: l.joinRyzeAI,
      topTrailingWidget: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/register'),
        child: Text(
          l.signup_tab ?? "Register",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      formContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo Email
          AuthInputField(
            controller: _emailController,
            label: l.email,
            hintText: l.enterEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          // Campo Contraseña
          AuthInputField(
            controller: _passwordController,
            label: l.password,
            hintText: l.enterYourPassword,
            isPassword: true,
            obscureText: _obscurePassword,
            onToggleVisibility: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 10),

          // Recordarme y Olvidé mi contraseña
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: Colors.black,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.remember_me,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.darkTextPrimary 
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecoverPasswordPage(),
                    ),
                  );
                },
                child: Text(
                  l.forgot_password_link ?? "Forgot Password?",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.darkTextPrimary 
                        : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Botón negro principal
          AuthPrimaryButton(
            label: l.login_tab ?? "Sign In",
            isLoading: _isLoading,
            onPressed: _iniciarSesion,
          ),
        ],
      ),
    );
  }
}