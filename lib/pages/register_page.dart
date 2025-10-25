import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stiv/shared/components/squared_tile.dart';
import 'package:stiv/shared/components/stiv_login_button.dart';
import 'package:stiv/shared/components/stiv_textfield.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Dentro de build():

  final user = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool passwordsmatch = true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    for (final c in [
      nameController,
      emailController,
      passwordController,
      confirmPasswordController,
    ]) {
      c.addListener(_onFieldsChanged);
    }
   
  }

  void _onFieldsChanged() {
    final match =
        passwordController.text.trim() == confirmPasswordController.text.trim();

    if (match != passwordsmatch) {
      setState(() {
        passwordsmatch = match;
      });
    } else {
      // Si las contraseñas no cambiaron, igual forzamos rebuild
      // para que canSubmit responda a nombre/correo.
      setState(() {});
    }
  }

 Future<void> signUserUp() async {
  if (_isLoading) return;           // evita doble toque
  setState(() => _isLoading = true);

  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
        .timeout(const Duration(seconds: 25)); // evita cuelgues infinitos

    // si navegas tras crear cuenta, hazlo aquí (sin dialog que cerrar)
    // Navigator.pushReplacementNamed(context, '/home');

  } on TimeoutException {
    _showErrorMessage('La solicitud tardó demasiado. Verifica tu conexión.');
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        _showErrorMessage('El correo electrónico ya está registrado.');
        break;
      case 'invalid-email':
        _showErrorMessage('El formato del correo no es válido.');
        break;
      case 'weak-password':
        _showErrorMessage('La contraseña es demasiado débil.');
        break;
      default:
        _showErrorMessage('Error al crear la cuenta. Inténtalo de nuevo.');
    }
  } catch (_) {
    _showErrorMessage('Ocurrió un error inesperado.');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          icon: const Icon(Icons.error, color: Colors.red),
          content: Text(textAlign: TextAlign.center, message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void wrongCredentialsMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          icon: const Icon(Icons.error, color: Colors.red),
          content: const Text(
            textAlign: TextAlign.center,
            'Usuario o contraseña invalidas.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit =
        passwordsmatch &&
        emailController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;

    final bool showPasswordMismatch =
        confirmPasswordController.text.isNotEmpty && !passwordsmatch;

    final String? confirmErrorText = showPasswordMismatch
        ? 'Las contraseñas no coinciden'
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // aplication icon
                  Image(
                    image: const AssetImage('assets/images/stiv-logo-blue.png'),
                    height: 120,
                    width: 120,
                  ),
            
                  // title
                  Text(
                    'Bienvenido a Stiv',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // subtitle
                  Text(
                    "Crea una cuenta para continuar",
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
            
                  // Input de full name
                  StivTextField(
                    hintText: 'Nombre completo',
                    obscureText: false,
                    controller: nameController,
                  ),
            
                  const SizedBox(height: 10),
            
                  // Input de email
                  StivTextField(
                    hintText: 'Correo electrónico',
                    obscureText: false,
                    controller: emailController,
                  ),
            
                  const SizedBox(height: 10),
            
                  // password textfield
                  StivTextField(
                    hintText: 'Contraseña',
                    obscureText: true,
                    controller: passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {},
                    ),
                  ),
            
                  const SizedBox(height: 10),
            
                  // confirmn password textfield
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StivTextField(
                        hintText: 'Confirmar contraseña',
                        obscureText: true,
                        borderColor: showPasswordMismatch
                            ? Colors.red
                            : AppColors.textSecondary,
                        controller: confirmPasswordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility_off,
                            color: showPasswordMismatch
                                ? Colors.red
                                : AppColors.textSecondary,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 5),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: confirmErrorText == null
                            ? const SizedBox.shrink(key: ValueKey('no-error'))
                            : Padding(
                                key: const ValueKey('error-text'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                ),
                                child: Text(
                                  confirmErrorText,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 20),
                  // Botón de inicio de sesión
                  LoginButton(
                    onTap: canSubmit ? signUserUp : null,
                    buttonText: 'Registrarse',
                    disabled: !canSubmit || _isLoading,
                  ),
            
                  const SizedBox(height: 10),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 0.5, color: Colors.grey[400]),
                        ),
            
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            " O inicia sesión con ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
            
                        Expanded(
                          child: Divider(thickness: 0.5, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
            
                  const SizedBox(height: 20),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(imagePath: 'assets/images/google.png'),
                      const SizedBox(width: 25),
                      SquareTile(imagePath: 'assets/images/apple.png'),
                    ],
                  ),
            
                  const SizedBox(height: 20),
                  // Registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿Ya tienes una cuenta?",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Inicia sesion ahora",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
            ),
            
            if (_isLoading) ...[
          const ModalBarrier(dismissible: false, color: Colors.black26),
          const Center(child: CircularProgressIndicator()),
          ],
          ],   
        ),
      ),
    );
  }
}
