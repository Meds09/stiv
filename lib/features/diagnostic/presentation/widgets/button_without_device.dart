import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

class ButtonWithoutDevice extends StatelessWidget {
  const ButtonWithoutDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){},
      style: AppButtonStyles.primary,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Continuar sin un dispositivo',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
      
    );
  }
}
