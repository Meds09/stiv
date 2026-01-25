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
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        hintText: 'Buscar...',
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: WidgetStatePropertyAll(AppColors.card),
        elevation: WidgetStatePropertyAll(6),
        leading: const Icon(Icons.search, color: AppColors.primary,),
        onChanged: (query) {
          ref.read(deviceSearchQueryProvider.notifier).state = query;
        },
      ),
    );
  }
}
