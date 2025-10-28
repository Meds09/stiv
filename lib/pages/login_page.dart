import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    //loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if(!mounted) return;
      Navigator.pop(context); //close the loading indicator
    } on FirebaseAuthException catch (e) {
      if(!mounted) return;
      Navigator.pop(context); //close the loading indicator
      if (e.code == 'invalid-credential') {
        wrongCredentialsMessage();
      } 
    }

  }

  void wrongCredentialsMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
          content: const Text(
            textAlign: TextAlign.center,
            'Usuario o contraseña invalidas.'),
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
              Image(image: const AssetImage('assets/images/stiv-logo-blue.png'), height: 120, width: 120,),
            
              // Título
              Text(
                'Bienvenido a Stiv',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              // Subtítulo
              Text(
                "Tu asistente de diagnostico técnico inteligente",
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Input de usuario
              StivTextField(
                floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                labelStyle: TextStyle(color: AppColors.textSecondary),
                label: 'Usuario o Correo electrónico',
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
                floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                labelStyle: TextStyle(color: AppColors.textSecondary),
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
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
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
                    "¿No tienes una cuenta?",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Registrate ahora",
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
      ),
    );
  }
}
