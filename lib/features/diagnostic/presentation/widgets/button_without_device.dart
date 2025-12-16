import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class ButtonWithoutDevice extends StatelessWidget {
  const ButtonWithoutDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){},
      style: AppButtonStyles.primary,
      child: const Text('Continuar sin un dispositivo'),
      
    );
  }
}
