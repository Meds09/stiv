import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/shared/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _profileAppbar(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
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
                      : const AssetImage('assets/images/avatar.png')
                            as ImageProvider,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _profileAppbar() {
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.primary),
      backgroundColor: AppColors.background,
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        color: AppColors.textPrimary,
      ),
      title: Text('Perfil'),
    );
  }
}
