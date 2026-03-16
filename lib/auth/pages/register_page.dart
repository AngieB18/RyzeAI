// lib/auth/pages/register_page.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/validators/register_validators.dart';
import '../widgets/password_strength_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          const SnackBar(
            content: Text('Debes aceptar los términos para continuar'),
            backgroundColor: AppColors.passwordWeak,
          ),
        );
        return;
      }

      try {
        // Crear usuario en Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        String uid = userCredential.user!.uid;

        // Guardar información adicional en Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada correctamente')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error al registrar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                    // Paso
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Paso 1 de 1',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Barra de progreso
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: AppColors.inputBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Únete a RyzeAI y empieza a decorar',
                      style: TextStyle(
                        color: AppColors.textSecondary,
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
                              label: 'Nombre',
                              placeholder: 'Ingresa tu nombre en este campo',
                              validator: RegisterValidators.validateFirstName,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _lastNameController,
                              label: 'Apellido',
                              placeholder: 'Ingresa tu apellido en este campo',
                              validator: RegisterValidators.validateLastName,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        placeholder: 'Digita tu email aquí',
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
                        label: 'Contraseña',
                        placeholder: 'Crea una contraseña segura',
                        obscureText: !_showPassword,
                        onChanged: (v) => setState(() => _passwordValue = v),
                        validator: RegisterValidators.validatePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
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
                        label: 'Confirmar contraseña',
                        placeholder: 'Confirma tu contraseña',
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
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          onPressed: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
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
                              side: const BorderSide(
                                color: AppColors.textSecondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(text: 'Al registrarte aceptas los '),
                                  TextSpan(
                                    text: 'Términos de servicio',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                  TextSpan(text: ' y la '),
                                  TextSpan(
                                    text: 'Política de privacidad',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Botón
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
                          child: const Text(
                            'Crear Cuenta',
                            style: TextStyle(
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
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
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
