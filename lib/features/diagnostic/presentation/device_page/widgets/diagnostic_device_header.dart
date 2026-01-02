import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/device.dart';

class DiagnosticHeader extends StatelessWidget {
  final Device device;

  const DiagnosticHeader({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 250),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: device.image != null
                            ? AssetImage(device.image!)
                            : null,
                        child: device.image == null
                            ? Icon(
                                Icons.devices,
                                size: 50,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                Text(
                  device.name,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Modelo: ${device.model}',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'IP: ${device.ip}',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),

                Text(
                  device.location != null
                      ? 'Ubicación: ${device.location}'
                      : 'Ubicación: No disponible ',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
