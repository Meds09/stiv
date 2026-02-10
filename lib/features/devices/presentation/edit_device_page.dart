import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/core/utils/toast_utils.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart';
import 'package:stiv/features/devices/presentation/widgets/device_image_picker.dart';
import 'package:stiv/features/devices/providers/image_upload_provider.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/devices/domain/models/device.dart';

class EditDevicePage extends ConsumerStatefulWidget {
  final String deviceId;
  const EditDevicePage({super.key, required this.deviceId});

  @override
  ConsumerState<EditDevicePage> createState() => _EditDevicePageState();
}

class _EditDevicePageState extends ConsumerState<EditDevicePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _ipController;
  late TextEditingController _locationController;

  int? _selectedCategoryId;
  bool _isLoading = false;
  bool _isInit = false; // To track if we populated data
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  // Modified to handle image upload
  Future<void> _updateDeviceWithImage(Device device) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String? imageUrl = device.image;

      // Upload new image if selected
      if (_selectedImage != null) {
        imageUrl = await ref
            .read(imageUploadServiceProvider)
            .uploadDeviceImage(_selectedImage!, device.id);
      }

      final updatedDevice = device.copyWith(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        ip: _ipController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        categoryId: _selectedCategoryId!,
        image: imageUrl,
      );

      await ref.read(deviceRepositoryProvider).updateDevice(updatedDevice);

      if (mounted) {
        context.pop();
        ToastUtils.showSuccess(context, 'Dispositivo actualizado correctamente');
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, 'Error al actualizar: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _brandController = TextEditingController();
    _modelController = TextEditingController();
    _ipController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _ipController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Eliminar Dispositivo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este dispositivo? Esta acción no se puede deshacer.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(deviceRepositoryProvider).deleteDevice(widget.deviceId);
      if (mounted) {
        context.pop();
        ToastUtils.showInfo(context, 'Dispositivo eliminado correctamente');
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, 'Error al eliminar: $e');
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch Categories
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar Dispositivo', style: AppTextStyles.h2),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          // Watch Device Data
          final deviceAsync = ref.watch(
            deviceByIdFutureProvider(widget.deviceId),
          );

          return deviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Error cargando dispositivo: $e')),
            data: (device) {
              if (device == null) {
                return const Center(child: Text('Dispositivo no encontrado'));
              }

              // Populate controllers once
              if (!_isInit) {
                _nameController.text = device.name;
                _brandController.text = device.brand;
                _modelController.text = device.model;
                _ipController.text = device.ip;
                _locationController.text = device.location ?? '';
                _selectedCategoryId = device.categoryId;
                _isInit = true;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DeviceImagePicker(
                        imageUrl: device.image,
                        localImage: _selectedImage,
                        onEditTap: _pickImage,
                      ),

                      const SizedBox(height: AppSpacing.md),
                      const SizedBox(height: AppSpacing.md),

                      _buildTextField(
                        controller: _nameController,
                        label: 'Nombre del dispositivo',
                        icon: Icons.devices,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildDropdown(categories),

                      const SizedBox(height: AppSpacing.md),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _brandController,
                              label: 'Marca',
                              icon: Icons.branding_watermark,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildTextField(
                              controller: _modelController,
                              label: 'Modelo',
                              icon: Icons.model_training,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildTextField(
                        controller: _ipController,
                        label: 'Dirección IP',
                        icon: Icons.wifi,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildTextField(
                        controller: _locationController,
                        label: 'Ubicación (Opcional)',
                        icon: Icons.location_on,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _updateDeviceWithImage(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Actualizar Dispositivo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _delete,
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: const Text(
                          'Eliminar Dispositivo',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        style:
                            OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              side: BorderSide(
                                color: Colors.red.shade400,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // Overlay rojo transparente al presionar
                              overlayColor: Colors.red.withValues(alpha: 0.08),
                              // Efecto de elevación sutil
                              elevation: 0,
                            ).copyWith(
                              // Personalizar el overlay para el estado presionado
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.red.withValues(alpha: 0.12);
                                    }
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.red.withValues(alpha: 0.06);
                                    }
                                    return null;
                                  }),
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primary.withValues(alpha: 0.7),
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.card,

        // Border styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
        ),

        // Content padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        // Error style
        errorStyle: TextStyle(
          color: Colors.red.shade400,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown(List<Category> categories) {
    return DropdownButtonFormField<int>(
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: AppColors.card,
      decoration: InputDecoration(
        labelText: 'Categoría',
        labelStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          Icons.category,
          color: AppColors.primary.withValues(alpha: 0.7),
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.card,

        // Border styling matching TextFields
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        errorStyle: TextStyle(
          color: Colors.red.shade400,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      initialValue: _selectedCategoryId,
      items: categories.map((c) {
        return DropdownMenuItem<int>(
          value: c.id,
          child: Text(
            '${c.emoji} ${c.name}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (val) {
        setState(() => _selectedCategoryId = val);
      },
      validator: (val) => val == null ? 'Requerido' : null,
    );
  }
}
