import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/shared/components/components.dart';
import 'package:stiv/shared/theme/theme_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  //sign out user
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final firstName =
        (user?.displayName ?? user?.email!)?.firstName.capitalized;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go("/login");
      });
    }
    return Scaffold(
      extendBody: true,
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
                          fontFamily: 'Rubik',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        '¡Bienvenido de nuevo!',
                        style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$firstName 👋',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                //Message banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Analicemos tus equipos en segundos',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(color: Colors.grey[350], thickness: 4),
                ),
                const SizedBox(height: 15),
              ],
            ),
            const SizedBox(height: 8),
            //Menu card section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CardMenu(
                    title: "Diagnóstico Rápido",
                    icon: const Icon(Icons.import_contacts_rounded),
                    onTap: () {
                      print('card tapped ');
                    },
                  ),
                ),
                Expanded(
                  child: CardMenu(
                    title: "Dispositivos",
                    icon: const Icon(Icons.devices),
                    onTap: (){},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CardMenu(
                    title: "Historial de reportes",
                    icon: const Icon(Icons.history),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: CardMenu(
                    title: "Manuales / Guías técnicas",
                    icon: const Icon(Icons.menu_book_rounded),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //stats
      //cards
      //footer
    );
  }
}
