import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class DeviceFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeviceFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: AppColors.primary,
        label: const Text(
          'Agregar dispositivo',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        icon: const Icon(Icons.add_circle_rounded, color: Colors.white, size: 24,),
        elevation: 6,

      ),
    );
  }
}
