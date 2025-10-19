import 'package:flutter/material.dart';
import 'package:stiv/shared/components/stiv_textfield.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  //
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Icono de la aplicación
              Icon(Icons.lock, size: 100, color: AppColors.primary),
              const SizedBox(height: 20),
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
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  
                )
              ),
              const SizedBox(height: 20),

            // Input de usuario
             StivTextField(
                hintText: 'Usuario o Correo electrónico',
                obscureText: false,
                controller: usernameController,
                suffixIcon: IconButton(
                  icon: Icon(Icons.person, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
             ),

             const SizedBox(height: 15),
             // Input de contraseña
              StivTextField(
                hintText: 'Contraseña',
                obscureText: true,
                controller: passwordController,
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility_off, color: AppColors.textSecondary),
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
            ]          
          ),
        ),
      ),
    );
  }
}
