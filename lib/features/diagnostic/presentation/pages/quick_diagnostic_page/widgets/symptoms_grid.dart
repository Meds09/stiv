import 'package:flutter/material.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/widgets/symptom.dart';
import 'package:stiv/features/diagnostic/presentation/pages/quick_diagnostic_page/widgets/symptom_card.dart';

/// Grid 2×3 con los síntomas comunes de diagnóstico.
class SymptomsGrid extends StatelessWidget {
  const SymptomsGrid({super.key});

  static const _symptoms = [
    Symptom(
      id: 'power_issue',
      label: 'No enciende',
      description: 'Sin señales de energía',
      icon: Icons.power_settings_new_rounded,
    ),
    Symptom(
      id: 'connectivity_issue',
      label: 'Sin conexión',
      description: 'Red no detectada',
      icon: Icons.wifi_off_rounded,
    ),
    Symptom(
      id: 'display_issue',
      label: 'Imagen borrosa',
      description: 'Calidad de video baja',
      icon: Icons.blur_on_rounded,
    ),
    Symptom(
      id: 'audio_issue',
      label: 'Ruido extraño',
      description: 'Sonidos del hardware',
      icon: Icons.graphic_eq_rounded,
    ),
    Symptom(
      id: 'camera_issue',
      label: 'Cámara falla',
      description: 'No graba o sin imagen',
      icon: Icons.videocam_off_rounded,
    ),
    Symptom(
      id: 'other_issue',
      label: 'Otro problema',
      description: 'Consultar con IA',
      icon: Icons.help_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.05,
      ),
      itemCount: _symptoms.length,
      itemBuilder: (context, index) {
        final s = _symptoms[index];
        return SymptomCard(
          symptom: s,
          onTap: () {
            router.pushNamed(
              'diagnostic-flow',
              pathParameters: {'symptomId': s.id},
            );
          },
        );
      },
    );
  }
}

