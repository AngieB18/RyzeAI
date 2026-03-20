import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/validators/register_validators.dart';
import '../widgets/password_strength_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../generated/l10n.dart';
import '../../core/settings/language_selector.dart';

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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).acceptTermsError),
            backgroundColor: AppColors.passwordWeak,
          ),
        );
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'language': Localizations.localeOf(context).languageCode,
          'theme': 'dark',
          'created_at': Timestamp.now(),
        });

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(S.of(context).accountCreated)));

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? S.of(context).registerError),
            backgroundColor: AppColors.passwordWeak,
          ),
        );
      }
    }
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
                            valueColor: AlwaysStoppedAnimation<Color>(
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
                              onPressed: () => setState(
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
                              onPressed: () => setState(
                                () => _showConfirmPassword =
                                    !_showConfirmPassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Términos
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (v) =>
                                      setState(() => _acceptTerms = v ?? false),
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
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: AppColors.textSecondary(context),
                                      fontSize: 12,
                                    ),
                                    children: [
                                      TextSpan(text: S.of(context).termsIntro),
                                      TextSpan(
                                        text: S.of(context).termsOfService,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(text: S.of(context).andThe),
                                      TextSpan(
                                        text: S.of(context).privacyPolicy,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
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
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
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
          style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
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
