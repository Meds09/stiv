import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class DeviceStatusIndicator extends ConsumerWidget {
  final String deviceId;
  final Color color;

  const DeviceStatusIndicator(this.color, {super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      deviceByIdProvider(deviceId).select((async) => async.value?.status),
    );

    if (status == null) {
      return const SizedBox.shrink();
    }

    final config = _statusConfig(status);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: config.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          config.label,
          style:  TextStyle(
            fontFamily: 'Rubik',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color
          ),
        ),
      ],
    );
  }
}

class _DeviceStatusConfig {
  final String label;
  final Color color;

  const _DeviceStatusConfig(this.label, this.color);
}

_DeviceStatusConfig _statusConfig(DeviceStatus status) {
  switch (status) {
    case DeviceStatus.offline:
      return const _DeviceStatusConfig('Falla registrada', Colors.redAccent);
    case DeviceStatus.online:
      return const _DeviceStatusConfig('Registrado', Colors.lightGreenAccent);
    case DeviceStatus.maintenance:
      return const _DeviceStatusConfig('Mantenimiento', Colors.yellowAccent);
  }
}
