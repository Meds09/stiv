import 'package:flutter/material.dart';
import 'package:stiv/features/diagnostic/models/device.dart';

class DeviceStatusIndicator extends StatefulWidget {
  final DeviceStatus status;

  const DeviceStatusIndicator({
    super.key,
    required this.status,
  });

  @override
  State<DeviceStatusIndicator> createState() =>
      _DeviceStatusIndicatorState();
}

class _DeviceStatusIndicatorState extends State<DeviceStatusIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  bool get _shouldAnimate =>
      widget.status == DeviceStatus.online || widget.status == DeviceStatus.offline || widget.status == DeviceStatus.maintenance;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (_shouldAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant DeviceStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_shouldAnimate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(widget.status);

    Widget dot = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: config.color,
        shape: BoxShape.circle,
      ),
    );

    if (_shouldAnimate) {
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
      return _DeviceStatusConfig(
        'Registrado',
        Colors.lightGreenAccent
      );
    default:
      return _DeviceStatusConfig(
        'Mantenimiento',
        Colors.yellowAccent
      );
  }
}
