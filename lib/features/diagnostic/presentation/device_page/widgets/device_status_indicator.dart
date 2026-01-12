import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/diagnostic/models/device.dart';
import 'package:stiv/features/diagnostic/presentation/providers/catalog_providers.dart';


class DeviceStatusIndicator extends ConsumerStatefulWidget {
  final int deviceId;

  const DeviceStatusIndicator({
    super.key,
    required this.deviceId,
  });

  @override
  ConsumerState<DeviceStatusIndicator> createState() =>
      _DeviceStatusIndicatorState();
}

class _DeviceStatusIndicatorState
    extends ConsumerState<DeviceStatusIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  DeviceStatus? _lastStatus;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  bool _shouldAnimate(DeviceStatus status) {
    return status == DeviceStatus.online ||
        status == DeviceStatus.offline ||
        status == DeviceStatus.maintenance;
  }

  @override
 @override
Widget build(BuildContext context) {
  final status = ref.watch(
    deviceByIdProvider(widget.deviceId)
        .select((async) => async.value?.status),
  );

  if (status == null) {
    return const SizedBox.shrink();
  }

  if (_lastStatus != status) {
    _lastStatus = status;
    if (_shouldAnimate(status)) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  final config = _statusConfig(status);

  Widget dot = Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: config.color,
      shape: BoxShape.circle,
    ),
  );

  if (_shouldAnimate(status)) {
    dot = FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: dot,
      ),
    );
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      dot,
      const SizedBox(width: 6),
      Text(
        config.label,
        style: const TextStyle(
          fontFamily: 'Rubik',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ],
  );
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      return const _DeviceStatusConfig(
        'Falla registrada',
        Colors.redAccent,
      );
    case DeviceStatus.online:
      return const _DeviceStatusConfig(
        'Registrado',
        Colors.lightGreenAccent,
      );
    case DeviceStatus.maintenance:
      return const _DeviceStatusConfig(
        'Mantenimiento',
        Colors.yellowAccent,
      );
  }
}
