import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart';
import 'package:stiv/features/diagnostic/models/category.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class AddNewDevicePage extends ConsumerStatefulWidget {
  const AddNewDevicePage({super.key});

  @override
  ConsumerState<AddNewDevicePage> createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends ConsumerState<AddNewDevicePage> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _ipController = TextEditingController();
  final _locationController = TextEditingController();
  
  int? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _ipController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor seleccione una categoría')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newDevice = Device(
        id: '', // Firestore will assign/we let repo handle if empty, actually repo.create logic needs review
        // Wait, repository impl checks "if id is empty, add()".
        // So this is correct.
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        ip: _ipController.text.trim(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        categoryId: _selectedCategoryId!,
        status: DeviceStatus.offline, // Default status
        image: null, // No image upload for now
      );

      await ref.read(deviceRepositoryProvider).createDevice(newDevice);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dispositivo creado exitosamente')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear dispositivo: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agregar Dispositivo', style: AppTextStyles.h2),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error cargando categorías: $e')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No hay categorías disponibles.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nombre del dispositivo',
                    icon: Icons.devices,
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
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
                          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildTextField(
                          controller: _modelController,
                          label: 'Modelo',
                          icon: Icons.model_training,
                          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
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
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  _buildTextField(
                    controller: _locationController,
                    label: 'Ubicación (Opcional)',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
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
                            'Guardar Dispositivo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade600,
            width: 2.0,
          ),
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade600,
            width: 2.0,
          ),
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
      value: _selectedCategoryId,
      items: categories.map((c) {
        return DropdownMenuItem<int>(
          value: c.id,
          child: Text(
            '${c.emoji} ${c.name}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
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
