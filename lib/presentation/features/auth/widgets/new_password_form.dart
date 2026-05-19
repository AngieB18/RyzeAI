import 'package:flutter/material.dart';

class NewPasswordForm extends StatelessWidget {

  final TextEditingController controller;
  final bool obscurePassword;
  final bool loading;
  final VoidCallback onToggleVisibility;
  final VoidCallback onUpdate;

  const NewPasswordForm({
    super.key,
    required this.controller,
    required this.obscurePassword,
    required this.loading,
    required this.onToggleVisibility,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Container(

          constraints: const BoxConstraints(
            maxWidth: 420,
          ),

          padding: const EdgeInsets.all(28),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(28),

            boxShadow: [

              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(

                width: 90,
                height: 90,

                decoration: BoxDecoration(

                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.lock_reset_rounded,
                  size: 45,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Nueva contraseña',

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(

                'Ingresa una nueva contraseña para continuar.',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 32),

              TextField(

                controller: controller,

                obscureText: obscurePassword,

                decoration: InputDecoration(

                  hintText: 'Nueva contraseña',

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),

                  suffixIcon: IconButton(

                    icon: Icon(

                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,

                    ),

                    onPressed:
                        onToggleVisibility,
                  ),

                  filled: true,

                  fillColor:
                      Colors.grey.shade100,

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(16),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  onPressed:
                      loading
                          ? null
                          : onUpdate,

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.orange,

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),

                  child:

                      loading

                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )

                          : const Text(

                              'Actualizar contraseña',

                              style: TextStyle(
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
    );
  }
}