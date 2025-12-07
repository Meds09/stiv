import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Modelo para una tarjeta de estadística de dispositivo
class DeviceStatCardData {
  final String label;
  final String value;
  final String emoji;
  final Color color;
  final List<int> history;
  final VoidCallback? onActionTap;
  final String? actionLabel;

  const DeviceStatCardData({
    required this.label,
    required this.value,
    required this.emoji,
    required this.color,
    required this.history,
    this.onActionTap,
    this.actionLabel,
  });
}

/// Tarjeta de estadística de dispositivo con gráfico y botón de acción
class DeviceStatCard extends StatefulWidget {
  final DeviceStatCardData data;
  final int index;

  const DeviceStatCard({
    super.key,
    required this.data,
    this.index = 0,
  });

  @override
  State<DeviceStatCard> createState() => _DeviceStatCardState();
}

class _DeviceStatCardState extends State<DeviceStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.15,
          0.4 + (widget.index * 0.15),
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.15,
          0.4 + (widget.index * 0.15),
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.brMd,
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.data.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      widget.data.label,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                if (widget.data.onActionTap != null)
                  _buildActionButton(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.data.value,
              style: AppTextStyles.h1.copyWith(
                fontSize: 36,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMiniChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    if (widget.data.onActionTap == null) return const SizedBox.shrink();

    return Material(
      color: widget.data.color.withOpacity(0.1),
      borderRadius: AppRadii.brSm,
      child: InkWell(
        onTap: widget.data.onActionTap,
        borderRadius: AppRadii.brSm,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          child: Text(
            widget.data.actionLabel ?? 'Diagnosticar',
            style: TextStyle(
              color: widget.data.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniChart() {
    if (widget.data.history.isEmpty) {
      return const SizedBox(height: 40);
    }

    final maxValue = widget.data.history.reduce((a, b) => a > b ? a : b);
    final minValue = widget.data.history.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final normalizedRange = range > 0 ? range : 1;

    return SizedBox(
      height: 40,
      child: CustomPaint(
        painter: _LineChartPainter(
          data: widget.data.history,
          color: widget.data.color,
          maxValue: maxValue.toDouble(),
          minValue: minValue.toDouble(),
          range: normalizedRange.toDouble(),
        ),
        child: Container(),
      ),
    );
  }
}

/// Painter para dibujar el gráfico de línea simple
class _LineChartPainter extends CustomPainter {
  final List<int> data;
  final Color color;
  final double maxValue;
  final double minValue;
  final double range;

  _LineChartPainter({
    required this.data,
    required this.color,
    required this.maxValue,
    required this.minValue,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final normalizedValue = range > 0
          ? (data[i] - minValue) / range
          : 0.5;
      final y = size.height - (normalizedValue * size.height * 0.8) - (size.height * 0.1);
      final x = i * stepX;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Puntos en los datos
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final normalizedValue = range > 0
          ? (data[i] - minValue) / range
          : 0.5;
      final y = size.height - (normalizedValue * size.height * 0.8) - (size.height * 0.1);
      final x = i * stepX;

      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

