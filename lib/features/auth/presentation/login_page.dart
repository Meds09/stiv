import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/utils/toast_utils.dart';
import 'package:stiv/features/auth/widgets/squared_tile.dart';
import 'package:stiv/features/auth/widgets/stiv_login_button.dart';
import 'package:stiv/features/auth/widgets/stiv_textfield.dart';
import 'package:stiv/services/auth_service.dart';
import 'package:stiv/core/theme/theme_data.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = FirebaseAuth.instance.currentUser;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Cerrar indicador

      context.go('/home');
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      String message = '';

      // Mensajes de error específicos
      if (e.code == 'invalid-email') {
        message = 'Formato de correo inválido.';
      } else if (e.code == 'user-not-found') {
        message = 'No existe un usuario con este email.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else {
        message = 'Usuario o contraseña incorrectos.';
      }

      // Mostrar el error al usuario
      ToastUtils.showError(context, message);
    } catch (e) {
      Navigator.of(context).pop(); // cerrar sí o sí
      ToastUtils.showError(context, 'Error desconocido');
    }
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
            style: TextStyle(fontFamily: 'Inter'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Icono de la aplicación
              Image(
                image: const AssetImage('assets/images/stiv-logo-blue.png'),
                height: 120,
                width: 120,
              ),

              // Título
              const Text('Bienvenido a Stiv', style: AppTextStyles.h1),
              const SizedBox(height: 10),
              // Subtítulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Text(
                  "Tu asistente de diagnostico inteligente",
                  style: AppTextStyles.subtitle,
                ),
              ),
              const SizedBox(height: 20),

              // Input de usuario
              StivTextField(
                keyboardType: TextInputType.emailAddress,
                label: 'Correo electrónico',
                hintText: 'Usuario o Correo electrónico',
                obscureText: false,
                controller: emailController,
                suffixIcon: IconButton(
                  icon: Icon(Icons.person, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: 10),
              // Input de contraseña
              StivTextField(
                keyboardType: TextInputType.visiblePassword,
                label: 'Contraseña',
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

              const SizedBox(height: 20),
              // Enlace de "Olvidaste tu contraseña"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              // Botón de inicio de sesión
              LoginButton(onTap: signUserIn, buttonText: 'Iniciar sesión'),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[400]),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Text(
                        " O inicia sesión con ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
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
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'assets/images/google.png',
                  ),
                  const SizedBox(width: 25),
                  SquareTile(
                    onTap: () {},
                    imagePath: 'assets/images/apple.png',
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿No tienes una cuenta?",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Registrate ahora",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
