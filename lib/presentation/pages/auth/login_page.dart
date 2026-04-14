import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/pages/auth/recover_password_page.dart';
import '../../../generated/l10n.dart'; 
import 'package:ryzeai/presentation/widgets/global/global_loader.dart';
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
    final s = S.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarError(s.emptyFieldsError);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _mostrarError(s.invalidEmail);
      return;
    }

    try {

      GlobalLoader.show(context);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      GlobalLoader.hide(context);

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }

    } on FirebaseAuthException catch (e) {

      GlobalLoader.hide(context);

      String mensajeFriendly;

      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          mensajeFriendly = s.loginError;
          break;
        case 'invalid-email':
          mensajeFriendly = s.invalidEmail;
          break;
        default:
          mensajeFriendly = s.registerError;
      }

      _mostrarError(mensajeFriendly);

    } catch (e) {

      GlobalLoader.hide(context);
      _mostrarError(s.registerError);

    }
  }

  void _mostrarError(String mensaje) {

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 40,
              ),

              const SizedBox(height: 16),

              Text(
                "Error",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(

      hintText: hint,

      prefixIcon: Icon(icon),

      filled: true,

      fillColor: AppColors.surface(context),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {

    final s = S.of(context);

    return Scaffold(

      backgroundColor: AppColors.background(context),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: Column(

            children: [

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// LOGO

              Image.asset(
                "assets/LogoRyzeAI.png",
                height: 90,
              ),

              const SizedBox(height: 30),

              Text(
                s.welcomeBack,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                s.joinRyzeAI,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                ),
              ),

              const SizedBox(height: 30),

              /// FORM CARD

              Container(
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(

                  color: AppColors.surface(context),

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(.05),
                      offset: const Offset(0, 10),
                    )
                  ],
                ),

                child: Column(
                  children: [

                    /// EMAIL

                    TextField(
                      controller: _emailController,
                      decoration: _inputDecoration(
                        hint: s.enterEmail,
                        icon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,

                      decoration: _inputDecoration(
                        hint: s.enterYourPassword,
                        icon: Icons.lock_outline,
                      ).copyWith(

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
                    ),

                    const SizedBox(height: 8),

                    /// FORGOT PASSWORD

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RecoverPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          s.forgotPassword,
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// LOGIN BUTTON

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),

                          elevation: 0,
                        ),

                        onPressed: _iniciarSesion,

                        child: Text(
                          s.login,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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