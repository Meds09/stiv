import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stiv/pages/login_page.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //sign out user
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = (user.displayName ?? user.email!).firstName.capitalized;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        //appbar
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/stiv-logo-blue.png',
                        height: 50,
                      ),
                      Text(
                        'Stiv',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  //Settings button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: signUserOut,
                        child: Icon(
                          Icons.settings,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 20),
                      //Logout button
                      GestureDetector(
                        onTap: signUserOut,
                        child: Icon(Icons.logout, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            //welcome back message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                      '¡Bienvenido de nuevo! $firstName',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                //Message banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Comencemos realizando el diagnóstico de tus dispostivos',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(color: Colors.grey[350], thickness: 4),
                ),
                const SizedBox(height: 24),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      //stats
      //cards
      //footer
    );
  }
}
