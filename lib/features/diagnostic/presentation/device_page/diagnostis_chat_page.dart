import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'package:stiv/features/diagnostic/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/device_page/widgets/diagnostic_device_body.dart';
import 'package:stiv/features/diagnostic/presentation/device_page/widgets/diagnostic_device_header.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class DiagnosticChatPage extends ConsumerWidget {


  const DiagnosticChatPage({super.key, required this.deviceId, required this.device});

  final int deviceId;
  final Device? device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final deviceAsyncValue = ref.watch(deviceByIdProvider(deviceId));

    return Scaffold(
      body: deviceAsyncValue.when(
        data: (device) => device != null 
        ? Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Column(
              children: [
                DiagnosticHeader(device: device),
                const DiagnosticDeviceBody(),
           
                                  
              ],
            ),
          ),
        )
        : const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
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
    ),
  );
}