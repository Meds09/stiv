import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/router/router.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/devices/presentation/device_list_page.dart';
import 'package:stiv/features/devices/providers/devices_providers.dart';
import 'package:stiv/features/devices/widgets/device_floating_action_button.dart';

class DevicePage extends ConsumerWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedIds = ref.watch(isExpandedCategoryIdProviderFromDevicesPage);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            router.go( '/home');
            expandedIds.clear();
          },
        ),
        elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.primary),
    backgroundColor: AppColors.background,
    titleTextStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Image.asset('assets/images/stiv-logo-blue.png', height: 50),
        const SizedBox(width: AppSpacing.sm),
        const Text('Stiv', style: AppTextStyles.h2),
      ],
      )),
      body: 
      DeviceListPage(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric( vertical: 25.0),
        child: DeviceFloatingActionButton(onPressed: () {
          router.go('/devices/add');
        },)
      )
    );
  }
}
