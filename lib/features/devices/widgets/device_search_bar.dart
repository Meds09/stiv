import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart';

class DeviceSearchBar extends ConsumerStatefulWidget {
  const DeviceSearchBar({super.key});

  @override
  ConsumerState<DeviceSearchBar> createState() => _DeviceSearchBarState();
}

class _DeviceSearchBarState extends ConsumerState<DeviceSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SearchBar(
        hintText: 'Buscar...',
        hintStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter', fontWeight: FontWeight.w500),
        ),
        backgroundColor: WidgetStatePropertyAll(AppColors.surface),
        elevation: WidgetStatePropertyAll(2),
        shadowColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.1)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        leading: const Icon(Icons.search, color: AppColors.primary),
        onChanged: (query) {
          ref.read(deviceSearchQueryProvider.notifier).state = query;
        },
      ),
    );
  }
}
