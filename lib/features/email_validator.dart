// lib/shared/validators/email_validator.dart
class EmailValidatorX {
  // Retorna null si es válido (como espera TextFormField.validator)
  static String? validate(String? value, {String fieldName = 'Correo'}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Ingresa tu $fieldName';
    // Regex simple y efectiva: usuario@dominio.tld (2+ letras)
    const pattern = r'^[\w\.\-+%]+@([\w\-]+\.)+[A-Za-z]{2,}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(text)) return 'El $fieldName no es válido';
    return null;
  }

  // Útil si quieres validar programáticamente fuera del formulario
  static bool isValid(String? value) => validate(value) == null;
}
