// lib/core/validators/register_validators.dart
class RegisterValidators {
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'El nombre es obligatorio';
    if (value.length < 2) return 'El nombre debe tener al menos 2 caracteres';
    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$").hasMatch(value))
      return 'El nombre solo puede contener letras';
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'El apellido es obligatorio';
    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$").hasMatch(value))
      return 'El apellido solo puede contener letras';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty)
      return 'El correo electrónico es obligatorio';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
      return 'Ingresa un correo electrónico válido';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 8)
      return 'La contraseña debe tener al menos 8 caracteres';
    if (!value.contains(RegExp(r'[A-Z]')))
      return 'Incluye al menos una letra mayúscula';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Incluye al menos un número';
    if (!value.contains(RegExp(r'[!@#\$%^&*]')))
      return 'Incluye al menos un carácter especial (!@#\$...)';
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value != password) return 'Las contraseñas no coinciden';
    return null;
  }

  static int passwordStrength(String password) {
    if (password.length < 8) return 0;
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#\$%^&*]'));
    if (hasUpper && hasNumber && hasSpecial) return 2; // fuerte
    if (hasNumber || hasUpper) return 1; // media
    return 0; // débil
  }
}
