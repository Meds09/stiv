import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stiv/services/auth_service.dart';
import 'package:stiv/shared/components/squared_tile.dart';
import 'package:stiv/shared/components/stiv_login_button.dart';
import 'package:stiv/shared/components/stiv_textfield.dart';
import 'package:stiv/shared/theme/theme_data.dart';

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
  // Mostrar loader
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
    useRootNavigator: true,
  );

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    // No navegues aquí, GoRouter lo hace automáticamente
  } on FirebaseAuthException catch (e) {
    if (mounted) {
      if (e.code == 'invalid-credential') {
        wrongCredentialsMessage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Error al iniciar sesión')),
        );
      }
    }
  } finally {
    // Siempre cierra el loader
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
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
              Text(
                'Bienvenido a Stiv',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter'
                ),
              ),
              const SizedBox(height: 10),
              // Subtítulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Tu asistente de diagnostico inteligente",
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontFamily: 'Inter'),
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
                    Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: AppColors.primary
                        
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
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
                      child: Text(
                        " O inicia sesión con ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter'
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
                  Text(
                    "¿No tienes una cuenta?",
                    style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
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
