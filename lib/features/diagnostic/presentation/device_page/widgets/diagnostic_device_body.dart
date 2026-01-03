import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class DiagnosticDeviceBody extends StatelessWidget {
  const DiagnosticDeviceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:30.0),
      child: Column(
        children: [
          const Text('¿Que problema presenta el dispositivo?',
          style: AppTextStyles.t1),
          const SizedBox(height:20),
         
        ],
      )

    );
  }
}
