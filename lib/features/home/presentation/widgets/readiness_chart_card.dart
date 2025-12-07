import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Tarjeta que muestra el porcentaje de alistamiento de dispositivos
/// Similar al diseño de bpm de la imagen de referencia
class ReadinessChartCard extends StatefulWidget {
  final double currentPercentage;
  final List<double> history;
  final String label;

  const ReadinessChartCard({
    super.key,
    required this.currentPercentage,
    required this.history,
    this.label = 'Alistamiento',
  });

  @override
  State<ReadinessChartCard> createState() => _ReadinessChartCardState();
}

class _ReadinessChartCardState extends State<ReadinessChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.brLg,
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),
              _buildCurrentValue(),
              const SizedBox(height: AppSpacing.lg),
              _buildChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.label} AVG % ${widget.currentPercentage.toInt()}',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.show_chart,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                // TODO: Mostrar gráfico completo
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                // TODO: Compartir estadísticas
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentValue() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado de ${widget.label}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${widget.currentPercentage.toInt()}%',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 48,
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    if (widget.history.isEmpty) {
      return const SizedBox(height: 120);
    }

    final currentIndex = widget.history.length - 1;
    final days = ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'];

    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          _buildChartLine(),
          _buildCurrentIndicator(currentIndex),
          _buildDayLabels(days),
        ],
      ),
    );
  }

  Widget _buildChartLine() {
    final maxValue = widget.history.reduce((a, b) => a > b ? a : b);
    final minValue = widget.history.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final normalizedRange = (range > 0 ? range : 1.0).toDouble();

    return CustomPaint(
      size: const Size(double.infinity, 80),
      painter: _ReadinessChartPainter(
        data: widget.history,
        color: AppColors.primary,
        maxValue: maxValue,
        minValue: minValue,
        range: normalizedRange,
      ),
    );
  }

  Widget _buildCurrentIndicator(int currentIndex) {
    if (currentIndex < 0 || currentIndex >= widget.history.length) {
      return const SizedBox.shrink();
    }

    final maxValue = widget.history.reduce((a, b) => a > b ? a : b);
    final minValue = widget.history.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final normalizedRange = range > 0 ? range : 1;

    final currentValue = widget.history[currentIndex];
    final normalizedValue = normalizedRange > 0
        ? (currentValue - minValue) / normalizedRange
        : 0.5;

    final chartHeight = 80.0;
    final y = chartHeight - (normalizedValue * chartHeight * 0.8) - (chartHeight * 0.1);
    final stepX = MediaQuery.of(context).size.width / (widget.history.length - 1);
    final x = currentIndex * stepX;

    return Positioned(
      left: x - 1,
      top: y - 20,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: AppRadii.brSm,
            ),
            child: Text(
              '${currentValue.toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 2,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(1),
            ),
            child: CustomPaint(
              painter: _DashedLinePainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabels(List<String> days) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          return Text(
            day,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor() {
    if (widget.currentPercentage >= 90) {
      return AppColors.success;
    } else if (widget.currentPercentage >= 70) {
      return AppColors.warning;
    } else {
      return AppColors.danger;
    }
  }
}

/// Painter para dibujar el gráfico de línea de alistamiento
class _ReadinessChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double maxValue;
  final double minValue;
  final double range;

  _ReadinessChartPainter({
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
      ..strokeWidth = 3
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

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter para dibujar línea punteada vertical
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..strokeWidth = 2;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

