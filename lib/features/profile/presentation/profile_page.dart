import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/core/utils/toast_utils.dart';
import 'package:stiv/features/home/presentation/widgets/sign_out_overlay.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/profile/presentation/widgets/widgets.dart';
import 'package:stiv/features/profile/providers/profile_image_upload_provider.dart';

/// Página principal del perfil de usuario
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  XFile? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _selectedImage = image);
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isUploading = true);

    try {
      // Upload image to Firebase Storage
      final imageUrl = await ref
          .read(imageUploadServiceProvider)
          .uploadProfileImage(_selectedImage!, user.uid);

      // Update Firebase Auth user profile
      await user.updatePhotoURL(imageUrl);
      await user.reload();
      
      // Force refresh the auth state to update UI immediately
      ref.invalidate(authStateProvider);
      
      // Clear selected image after successful upload
      if (mounted) {
        setState(() {
          _selectedImage = null;
          _isUploading = false;
        });

        ToastUtils.showSuccess(
          context,
          'Foto de perfil actualizada con éxito',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ToastUtils.showError(
          context,
          'No se pudo actualizar la foto',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ProfileHeader(
                  user: user,
                  localImage: _selectedImage,
                  onAvatarEdit: _isUploading ? null : _pickImage,
                ),
                const SizedBox(height: AppSpacing.xl),
                _buildContent(user, authController, isSigningOut),
              ],
            ),
          ),
       
          SignOutOverlay(isVisible: isSigningOut),
          
          // Enhanced Upload overlay
          LoadingOverlay(
            isLoading: _isUploading,
            message: 'Actualizando tu perfil...',
          ),
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
            onTap: () {
              authController.signOut();
            },
  
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
