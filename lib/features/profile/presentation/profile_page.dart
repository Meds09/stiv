import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/login_register/providers/auth_provider.dart';
import 'package:stiv/features/profile/presentation/widgets/widgets.dart';


/// Página principal del perfil de usuario
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authController = ref.read(authControllerProvider);
    final isSigningOut = ref.watch(isSigningOutProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ProfileHeader(user: user),
                const SizedBox(height: AppSpacing.xl),
                _buildContent(user, authController, isSigningOut),
                
              ],
              
            ),
          ),
          LoadingOverlay(isLoading: isSigningOut),
          
          
          
        ],
        
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.primary),
      backgroundColor: AppColors.background,
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildContent(
    User? user,
    AuthController authController,
    bool isSigningOut,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Información Personal'),
          const SizedBox(height: AppSpacing.md),
          ProfileInfoSection(user: user),
          const SizedBox(height: AppSpacing.xl),
          const SectionTitle(title: 'Configuración'),
          const SizedBox(height: AppSpacing.md),
          const SettingsSection(),
          const SizedBox(height: AppSpacing.xl),
          LogoutButton(
            onTap: () => authController.signOut(),
            isLoading: isSigningOut,
            //TODO COPIAR EL LOGOUT DEL HOMEPAGE YA QUE ESE TIENE LA IMAGEN DE DESPEDIDA, DESDE LA PAGINA DE PERFIL NO.
          ),
          const SizedBox(height: 200),
          
        ],
        
        
      ),
      
    );
  }
}
