import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/shared/providers/auth_provider.dart';
import 'package:stiv/shared/widgets/stiv_text_container.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        backgroundColor: AppColors.background,
        titleTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAvatar(user: user),
            const SizedBox(height: 20),
            Center(
              child: Text(
                user?.displayName ?? 'Stiver',
                style: AppTextStyles.h1,
              ),
            ),
            Center(
              child: Text(user?.email ?? ' ', style: AppTextStyles.subtitle),
            ),
            const SizedBox(height: 40),
            StivTextContainer(
              suffixIcon: const Icon(
                Icons.badge_outlined,
                color: AppColors.primary,
              ),
              text: user?.email,
              title: 'Cargo',
            ),
            const SizedBox(height: 20),
            StivTextContainer(
              suffixIcon: const Icon(Icons.phone, color: AppColors.primary),
              text: user?.phoneNumber,
              title: 'Numero de telefono',
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Configuración',
                    style: AppTextStyles.h2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 4),
        ),
        child: CircleAvatar(
          radius: 65,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : const AssetImage('assets/images/avatar.png') as ImageProvider,
        ),
      ),
    );
  }
}
