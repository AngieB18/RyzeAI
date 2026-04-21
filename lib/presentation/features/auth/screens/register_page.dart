import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/validators/register_validators.dart';
import '../../../widgets/auth/password_strength_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/settings/language_selector.dart';

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

  bool _acceptTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  String _passwordValue = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Normalize email: trim + lowercase for consistency
  String _normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Show error dialog with user-friendly message
  void _showErrorDialog(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }

  /// Map Supabase auth errors to user-friendly messages
  String _getAuthErrorMessage(AuthException e) {
    if (e.message.contains('already registered')) {
      return S.of(context).emailAlreadyExists;
    }
    if (e.message.contains('weak password')) {
      return S.of(context).passwordTooWeak;
    }
    if (e.message.contains('invalid email')) {
      return S.of(context).invalidEmail;
    }
    // Default: return original message (or S.of(context).registerError)
    return e.message;
  }

  Future<void> _submit() async {
    // Prevent multiple submissions (rate limit protection)
    if (_isLoading) return;

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate terms acceptance
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).acceptTermsError),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
      return;
    }

    // Set loading state
    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final normalizedEmail = _normalizeEmail(_emailController.text);

      // Step 1: Create user in Supabase Auth
      // This creates auth.users entry
      final authResponse = await supabase.auth.signUp(
        email: normalizedEmail,
        password: _passwordController.text,
      );

      final user = authResponse.user;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).accountCreated),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to home, clear all previous routes
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on AuthException catch (e) {
      debugPrint('Auth error during registration: ${e.message}');

      if (!mounted) return;

      _showErrorDialog(
        S.of(context).registrationError,
        _getAuthErrorMessage(e),
      );

      setState(() => _isLoading = false);
    } on PostgrestException catch (e) {
      // Database constraint violations, RLS policy failures, etc.
      debugPrint('Database error during registration: ${e.message}');

      if (!mounted) return;

      final errorMessage = e.message.contains('unique')
          ? S.of(context).emailAlreadyExists
          : S.of(context).profileCreationFailed;

      _showErrorDialog(
        S.of(context).registrationError,
        errorMessage,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      // Unexpected error
      debugPrint('Unexpected error during registration: $e');

      if (!mounted) return;

      _showErrorDialog(
        S.of(context).registrationError,
        S.of(context).registerError,
      );

      setState(() => _isLoading = false);
    }
  }

  void _showTermsSheet(BuildContext context, {required bool isTerms}) {
    final l = S.of(context);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con color
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
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
                      color: AppColors.primary.withOpacity(0.2),
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
                        color: AppColors.textPrimary(context),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.inputBorder(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary(context),
                        size: 16,
                      ),
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
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),
            ),

            // Botón
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Banner superior ──────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A1F1A),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.textSecondary(context),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              S.of(context).step1of1,
                              style: TextStyle(
                                color: AppColors.textSecondary(context),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 1.0,
                            backgroundColor: AppColors.inputBorder(context),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).createAccount,
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.of(context).joinRyzeAI,
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Formulario ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre y Apellido
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _firstNameController,
                                  label: S.of(context).firstName,
                                  placeholder: S.of(context).enterFirstName,
                                  validator:
                                      RegisterValidators.validateFirstName,
                                  enabled: !_isLoading,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: _lastNameController,
                                  label: S.of(context).lastName,
                                  placeholder: S.of(context).enterLastName,
                                  validator:
                                      RegisterValidators.validateLastName,
                                  enabled: !_isLoading,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Email
                          _buildTextField(
                            controller: _emailController,
                            label: S.of(context).email,
                            placeholder: S.of(context).enterEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: RegisterValidators.validateEmail,
                            enabled: !_isLoading,
                            suffix: const Icon(
                              Icons.check,
                              color: AppColors.passwordStrong,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Contraseña
                          _buildTextField(
                            controller: _passwordController,
                            label: S.of(context).password,
                            placeholder: S.of(context).enterPassword,
                            obscureText: !_showPassword,
                            enabled: !_isLoading,
                            onChanged: (v) =>
                                setState(() => _passwordValue = v),
                            validator: RegisterValidators.validatePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondary(context),
                                size: 18,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                            ),
                          ),
                          if (_passwordValue.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            PasswordStrengthIndicator(password: _passwordValue),
                          ],
                          const SizedBox(height: 16),

                          // Confirmar contraseña
                          _buildTextField(
                            controller: _confirmPasswordController,
                            label: S.of(context).confirmPassword,
                            placeholder: S.of(context).confirmPasswordHint,
                            obscureText: !_showConfirmPassword,
                            enabled: !_isLoading,
                            validator: (v) =>
                                RegisterValidators.validateConfirmPassword(
                                  v,
                                  _passwordController.text,
                                ),
                            suffix: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondary(context),
                                size: 18,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () => setState(
                                        () => _showConfirmPassword =
                                            !_showConfirmPassword,
                                      ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Términos ─────────────────────
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
                                      : (v) => setState(
                                            () => _acceptTerms = v ?? false,
                                          ),
                                  activeColor: AppColors.primary,
                                  side: BorderSide(
                                    color: AppColors.textSecondary(context),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Wrap(
                                  children: [
                                    Text(
                                      S.of(context).termsIntro,
                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _isLoading
                                          ? null
                                          : () => _showTermsSheet(
                                                context,
                                                isTerms: true,
                                              ),
                                      child: Text(
                                        S.of(context).termsOfService,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      S.of(context).andThe,
                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _isLoading
                                          ? null
                                          : () => _showTermsSheet(
                                                context,
                                                isTerms: false,
                                              ),
                                      child: Text(
                                        S.of(context).privacyPolicy,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Botón crear cuenta
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading
                                    ? AppColors.primary.withOpacity(0.5)
                                    : AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.5),
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          S.of(context).creatingAccount ??
                                              'Creating account...',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      S.of(context).createAccountButton,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Botón de idioma flotante ─────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: const LanguageSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? placeholder,
    bool obscureText = false,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(color: AppColors.textPrimary(context), fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 14,
            ),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.surface(context),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.inputBorder(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.inputBorder(context)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.inputBorder(context).withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.passwordWeak),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.passwordWeak),
            ),
          ),
        ),
      ],
    );
  }
}
