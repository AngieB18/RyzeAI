import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/validators/register_validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart' show themeProvider;
import '../widgets/auth_custom_widgets.dart';
import '../../../../core/constants/app_assets.dart';
import '../widgets/register_widgets_terms_dialog.dart';
import '../widgets/register_widgets_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).acceptTermsError),
          backgroundColor: AppColors.passwordWeak,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final email = _emailController.text.trim().toLowerCase();

      // 1. Pick a random default avatar
      final randomAvatar = AppAssets.defaultAvatars[DateTime.now().millisecond % AppAssets.defaultAvatars.length];

      // 2. Sign up user
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: _passwordController.text,
        data: {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'photo_url': randomAvatar,
        },
      );

      final user = authResponse.user;
      if (user == null) throw Exception('Registration failed: User not created');

      // 3. Insert user profile into public.users table
      await supabase.from('users').insert({
        'id': user.id,
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'email': email,
        'language': Localizations.localeOf(context).languageCode,
        'theme': 'dark',
        'styles_selected': false,
        'styles': [],
        'photo_url': randomAvatar,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on AuthException catch (e) {
      _showErrorDialog(S.of(context).registrationError, e.message);
    } catch (e) {
      debugPrint('Registration error: $e');
      _showErrorDialog(
          S.of(context).registrationError, S.of(context).registerError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showTermsSheet({required bool isTerms}) {
    RegisterTermsDialog.show(
      context,
      isTerms: isTerms,
      onAccept: () => setState(() => _acceptTerms = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final isDark = themeProvider.isDark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textOnCard = isDark ? AppColors.darkTextPrimary : Colors.black87;
    final subTextOnCard = isDark ? AppColors.darkTextSecondary : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: AppColors.primarySoft,
      body: Column(
        children: [
          RegisterHeader(
            onBack: () => Navigator.pop(context),
            onLogin: () => Navigator.pushReplacementNamed(context, '/login'),
          ),

          // Form Card
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AuthInputField(
                              controller: _firstNameController,
                              label: l.firstName,
                              hintText: l.enterFirstName,
                              validator: RegisterValidators.validateFirstName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AuthInputField(
                              controller: _lastNameController,
                              label: l.lastName,
                              hintText: l.enterLastName,
                              validator: RegisterValidators.validateLastName,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      AuthInputField(
                        controller: _emailController,
                        label: l.email,
                        hintText: l.enterEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: RegisterValidators.validateEmail,
                      ),
                      const SizedBox(height: 24),

                      AuthInputField(
                        controller: _passwordController,
                        label: l.password,
                        hintText: l.enterPassword,
                        isPassword: true,
                        obscureText: !_showPassword,
                        onToggleVisibility: () =>
                            setState(() => _showPassword = !_showPassword),
                        validator: RegisterValidators.validatePassword,
                      ),
                      const SizedBox(height: 24),

                      AuthInputField(
                        controller: _confirmPasswordController,
                        label: l.confirmPassword,
                        hintText: l.confirmPasswordHint,
                        isPassword: true,
                        obscureText: !_showConfirmPassword,
                        onToggleVisibility: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                        validator: (v) =>
                            RegisterValidators.validateConfirmPassword(
                                v, _passwordController.text),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l.createAccountButton,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Terms Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: _isLoading
                                  ? null
                                  : (v) => setState(() => _acceptTerms = v ?? false),
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              side: BorderSide(
                                color: textOnCard.withOpacity(0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Wrap(
                              children: [
                                Text(
                                  l.terms_signup_intro ?? "By signing up you accept our ",
                                  style: TextStyle(
                                      color: subTextOnCard, fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: _isLoading
                                      ? null
                                      : () => _showTermsSheet(isTerms: true),
                                  child: Text(
                                    l.termsOfService,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  " ${l.andThe} ",
                                  style: TextStyle(
                                      color: subTextOnCard, fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: _isLoading
                                      ? null
                                      : () => _showTermsSheet(isTerms: false),
                                  child: Text(
                                    l.privacyPolicy,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
