// lib/shared/validators/email_validator.dart
import 'package:email_validator/email_validator.dart';

class EmailValidatorX {
  // Retorna null si es válido (como espera TextFormField.validator)
  static String? validate(String? value, {String fieldName = 'Correo'}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Ingresa tu $fieldName';
    if (!EmailValidator.validate(text)) return 'El $fieldName no es válido';
    return null;
  }
}
