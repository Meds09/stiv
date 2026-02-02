import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/devices/domain/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';

class StatusIndicator extends ConsumerWidget {
  final String deviceId;
  final Color color;

  const StatusIndicator(this.color, {super.key, required this.deviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      deviceByIdProvider(deviceId).select((async) => async.value?.status),
    );

    if (status == null) {
      return const SizedBox.shrink();
    }

    final config = _statusConfig(status);

    return Container(
      width:135,
      padding: EdgeInsets.symmetric(),
      height: 20,
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: config.color.lighten().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),child: Text(config.label, style: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: config.color,  
      )),
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
      return const _DeviceStatusConfig('Registrado', Color.fromARGB(255, 48, 137, 51));
    case DeviceStatus.maintenance:
      return const _DeviceStatusConfig('Mantenimiento', Color.fromARGB(255, 140, 140, 9));
  }
}
