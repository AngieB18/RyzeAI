import 'package:flutter/material.dart';
// Importamos tus constantes de colores y la página de recuperación
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/auth/pages/recover_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para capturar y leer lo que el usuario escribe en los campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable para controlar si la contraseña se ve (false) o está oculta (true)
  bool _obscurePassword = true;

  // Función que se ejecuta al presionar el botón de "Iniciar Sesión"
  void _iniciarSesion() {
    // .text obtiene el string y .trim() quita espacios vacíos al inicio o final
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Aquí imprimirás en consola para probar que los datos se capturan bien
    print("Intentando entrar con: $email y $password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos el color de fondo oscuro definido en tus constantes
      backgroundColor: AppColors.background,
      // AppBar transparente que solo muestra la flecha de regreso
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Sin color de fondo
        elevation: 0, // Sin sombra
        // Flecha de regreso a la página anterior (página principal)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context), // Regresa a la pantalla anterior
        ),
      ),
      body: SafeArea(
        // SingleChildScrollView evita errores si el teclado tapa la pantalla
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea todo a la izquierda
            children: [
              // --- SECCIÓN DE TÍTULOS ---
              const Text(
                "Bienvenido de vuelta",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Espaciado pequeño
              const Text(
                "Inicia sesión para continuar",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32), // Espaciado grande antes de los campos

              // --- CAMPO DE CORREO ELECTRÓNICO ---
              const Text(
                "Correo electrónico",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController, // Conectamos el controlador
                keyboardType: TextInputType.emailAddress, // Muestra el @ en el teclado
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: "maria@ejemplo.com", // Texto de sugerencia
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  suffixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface, // Fondo gris oscuro del campo
                  // Definimos los bordes redondeados para todos los estados
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary), // Borde naranja al tocar
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- CAMPO DE CONTRASEÑA ---
              const Text(
                "Contraseña",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController, // Conectamos el controlador
                obscureText: _obscurePassword, // Oculta el texto con puntos
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: "••••••••••",
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  // Icono de ojo que cambia el estado al presionarlo
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      // setState refresca la pantalla para mostrar/ocultar texto
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- BOTÓN OLVIDASTE TU CONTRASEÑA ---
              Align(
                alignment: Alignment.centerRight, // Lo mueve a la derecha
                child: TextButton(
                  onPressed: () {
                    // Navegación hacia la página de recuperar contraseña
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecoverPasswordPage()),
                    );
                  },
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- BOTÓN DE INICIAR SESIÓN ---
              SizedBox(
                width: double.infinity, // Hace que el botón ocupe todo el ancho
                height: 52, // Altura fija del botón
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Color naranja/café
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    ),
                  ),
                  onPressed: _iniciarSesion, // Llama a la función de arriba
                  child: const Text(
                    "Iniciar Sesión",
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
    );
  }
}