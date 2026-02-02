import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

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
        title: const Text('Eliminar Dispositivo'),
        content: const Text('¿Estás seguro de que deseas eliminar este dispositivo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(deviceRepositoryProvider).deleteDevice(widget.deviceId);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _isLoading ? null : _delete,
          )
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          // Watch Device Data
          final deviceAsync = ref.watch(deviceByIdFutureProvider(widget.deviceId));

          return deviceAsync.when(
             loading: () => const Center(child: CircularProgressIndicator()),
             error: (e, _) => Center(child: Text('Error cargando dispositivo: $e')),
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
                       _buildTextField(
                        controller: _nameController,
                        label: 'Nombre del dispositivo',
                        icon: Icons.devices,
                        validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          prefixIcon: const Icon(Icons.category, color: AppColors.primary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: AppColors.card,
                        ),
                        value: _selectedCategoryId,
                        items: categories.map((c) {
                          return DropdownMenuItem<int>(
                            value: c.id,
                            child: Text('${c.emoji} ${c.name}'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedCategoryId = val);
                        },
                        validator: (val) => val == null ? 'Requerido' : null,
                      ),

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
                        onPressed: _isLoading ? null : () async {
                           // Reconstruct device with preserved fields (like status, image, ID)
                           // We are inside 'data' block so 'device' is available.
                           // Actually we can pass 'device' to _submit or reconstruct here.
                           // Simpler: Just override _submit logic here or update _submit to use current form values + original device properties.
                           
                           if (!_formKey.currentState!.validate()) return;
                           
                           setState(() => _isLoading = true);
                           try {
                              final updated = device.copyWith(
                                name: _nameController.text.trim(),
                                brand: _brandController.text.trim(),
                                model: _modelController.text.trim(),
                                ip: _ipController.text.trim(),
                                location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
                                categoryId: _selectedCategoryId!,
                              );
                              
                              await ref.read(deviceRepositoryProvider).updateDevice(updated);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Actualizado correctamente')),
                                );
                                context.pop();
                              }
                           } catch(e) {
                              if(context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                              }
                           } finally {
                              if(mounted) setState(() => _isLoading = false);
                           }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Actualizar Dispositivo', style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
               );
             }
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.card,
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
