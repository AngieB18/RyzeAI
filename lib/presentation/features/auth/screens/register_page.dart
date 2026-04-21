import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/validators/register_validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart' show themeProvider;
import '../widgets/auth_custom_widgets.dart';

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
  bool _acceptTerms = false; // Checkbox de aceptación de términos

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

    // Validar que se aceptaron los términos
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

      final authResponse = await supabase.auth.signUp(
        email: email,
        password: _passwordController.text,
      );

      final user = authResponse.user;
      if (user == null) throw Exception('Registration failed');

      await supabase.from('users').insert({
        'id': user.id,
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'email': email,
        'language': Localizations.localeOf(context).languageCode,
        'theme': 'dark',
        'styles_selected': false,
        'styles': [],
        'created_at': DateTime.now().toIso8601String(),
      });

      if (user == null) {
        throw Exception('Registration failed: User not created');
      }

      // Step 2: Insert user profile into public.users table
      // This creates the user record in our database
      try {
        await supabase.from('users').insert({
          'id': user.id, // ✓ IMPORTANT: Must match auth.uid()
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': normalizedEmail,
          'language': Localizations.localeOf(context).languageCode,
          'theme': 'dark',
          'styles_selected': false,
          'styles': [],
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (dbError) {
        // Database insert failed - user is in auth but not in users table
        // This is inconsistent state. Log and inform user.
        debugPrint('Database insert error during registration: $dbError');

        if (!mounted) return;

        _showErrorDialog(
          S.of(context).registrationError,
          S.of(context).profileCreationFailed,
        );
        setState(() => _isLoading = false);
        return;
      }

      // Success: show confirmation and navigate
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on AuthException catch (e) {
      _showErrorDialog(S.of(context).registrationError, e.message);
    } catch (e) {
      _showErrorDialog(
          S.of(context).registrationError, S.of(context).registerError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Muestra el diálogo de Términos o Política de Privacidad
  void _showTermsSheet({required bool isTerms}) {
    final l = S.of(context);
    final isDark = themeProvider.isDark;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado naranja
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isTerms
                          ? Icons.description_outlined
                          : Icons.privacy_tip_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isTerms ? l.termsOfService : l.privacyPolicy,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // Contenido
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  isTerms ? l.termsContent : l.privacyContent,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),
            ),
            // Botón Aceptar y cerrar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() => _acceptTerms = true);
                    Navigator.pop(context);
                  },
                  child: Text(
                    l.acceptAndClose,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          // ── CABECERA NARANJA ─────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila: Back + "Sign In"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.black, size: 22),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          l.login_tab ?? "Sign In",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l.signup_tab ?? "Sign Up",
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.joinRyzeAI,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.65),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── TARJETA BLANCA (Formulario) ─────────────────────
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
                      // Nombre y Apellido en fila
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

                      // Email
                      AuthInputField(
                        controller: _emailController,
                        label: l.email,
                        hintText: l.enterEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: RegisterValidators.validateEmail,
                      ),
                      const SizedBox(height: 24),

                      // Password
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

                      // Confirmar Password
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

                      // Botón negro principal
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

                      // ── Checkbox de términos ──────────────────────
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
