import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedCircularChart extends StatefulWidget {
  final double totalDebt;
  final double totalPaid;
  final bool isDark;

  const AnimatedCircularChart({
    super.key,
    required this.totalDebt,
    required this.totalPaid,
    required this.isDark,
  });

  @override
  State<AnimatedCircularChart> createState() => _AnimatedCircularChartState();
}

class _AnimatedCircularChartState extends State<AnimatedCircularChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalDebt != widget.totalDebt ||
        oldWidget.totalPaid != widget.totalPaid) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.totalDebt + widget.totalPaid;
    final paidPercent = total > 0 ? widget.totalPaid / total : 0.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: CircularChartPainter(
            paidPercent: paidPercent * _animation.value,
            isDark: widget.isDark,
          ),
          child: child,
        );
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final animatedPercent =
                      (paidPercent * _animation.value * 100);
                  return Text(
                    '${animatedPercent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Repaid',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularChartPainter extends CustomPainter {
  final double paidPercent;
  final bool isDark;

  CircularChartPainter({required this.paidPercent, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 15;
    const strokeWidth = 16.0;

    // Background arc (outstanding debt)
    final backgroundPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Paid arc with gradient
    if (paidPercent > 0) {
      final paidSweep = 2 * math.pi * paidPercent;

      final paidPaint = Paint()
        ..shader = const SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [
            Color(0xFF00E676), // Green
            Color(0xFF00D9FF), // Cyan
            Color(0xFF6C63FF), // Purple
          ],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start from top
        paidSweep,
        false,
        paidPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularChartPainter oldDelegate) {
    return oldDelegate.paidPercent != paidPercent ||
        oldDelegate.isDark != isDark;
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final bool isDark;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
