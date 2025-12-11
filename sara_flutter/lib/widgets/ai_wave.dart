import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

enum WaveState {
  idle,
  welcoming,
  answering,
  thinking,
  listening,
}

class AIWave extends StatefulWidget {
  final WaveState state;
  final double size;

  const AIWave({
    super.key,
    required this.state,
    this.size = 200.0,
  });

  @override
  State<AIWave> createState() => _AIWaveState();
}

class _AIWaveState extends State<AIWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _getDuration(),
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(AIWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _controller.duration = _getDuration();
      if (_shouldAnimate()) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration _getDuration() {
    switch (widget.state) {
      case WaveState.idle:
        return const Duration(seconds: 3);
      case WaveState.welcoming:
        return const Duration(milliseconds: 1500);
      case WaveState.answering:
        return const Duration(seconds: 2);
      case WaveState.thinking:
        return const Duration(milliseconds: 800);
      case WaveState.listening:
        return const Duration(milliseconds: 1200);
    }
  }

  bool _shouldAnimate() {
    return widget.state != WaveState.idle;
  }

  Color _getColor() {
    switch (widget.state) {
      case WaveState.idle:
        return AppColors.primary;
      case WaveState.welcoming:
        return AppColors.secondary;
      case WaveState.answering:
        return AppColors.primary;
      case WaveState.thinking:
        return AppColors.primary.withValues(alpha: 0.8);
      case WaveState.listening:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(
              animation: _animation.value,
              state: widget.state,
              color: _getColor(),
            ),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animation;
  final WaveState state;
  final Color color;

  _WavePainter({
    required this.animation,
    required this.state,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 6;

    switch (state) {
      case WaveState.idle:
        _drawIdleState(canvas, center, baseRadius);
        break;
      case WaveState.welcoming:
        _drawWelcomingState(canvas, center, baseRadius);
        break;
      case WaveState.answering:
        _drawAnsweringState(canvas, center, baseRadius);
        break;
      case WaveState.thinking:
        _drawThinkingState(canvas, center, baseRadius);
        break;
      case WaveState.listening:
        _drawListeningState(canvas, center, baseRadius);
        break;
    }
  }

  void _drawIdleState(Canvas canvas, Offset center, double baseRadius) {
    // Single solid circle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius, paint);

    // Subtle outer ring
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, baseRadius * 1.5, ringPaint);
  }

  void _drawWelcomingState(Canvas canvas, Offset center, double baseRadius) {
    // Core circle
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius * 0.8, corePaint);

    // Expanding rings
    for (int i = 0; i < 3; i++) {
      final progress = (animation + (i / 3)) % 1.0;
      final radius = baseRadius + (baseRadius * 2 * progress);
      final opacity = (1.0 - progress) * 0.6;

      final ringPaint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(center, radius, ringPaint);
    }
  }

  void _drawAnsweringState(Canvas canvas, Offset center, double baseRadius) {
    // Pulsing core
    final pulseRadius = baseRadius * (0.9 + 0.2 * animation);
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, pulseRadius, corePaint);

    // Rotating arcs
    final arcPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final angle = (animation * 2 * 3.14159) + (i * 3.14159 / 2);
      final startAngle = angle;
      final sweepAngle = 3.14159 / 3;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: baseRadius * 1.8),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }
  }

  void _drawThinkingState(Canvas canvas, Offset center, double baseRadius) {
    // Core circle
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius * 0.7, corePaint);

    // Orbiting dots
    for (int i = 0; i < 3; i++) {
      final angle = (animation * 2 * math.pi) + (i * 2 * math.pi / 3);
      final offset = Offset(
        center.dx + baseRadius * 1.5 * math.cos(angle),
        center.dy + baseRadius * 1.5 * math.sin(angle),
      );

      final dotSize = baseRadius * 0.3 * (0.7 + 0.3 * math.sin(animation * 2 * math.pi));
      final dotPaint = Paint()
        ..color = color.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(offset, dotSize, dotPaint);
    }
  }

  void _drawListeningState(Canvas canvas, Offset center, double baseRadius) {
    // Core circle
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius * 0.8, corePaint);

    // Sound wave bars
    final barCount = 12;
    final angleStep = 2 * math.pi / barCount;

    for (int i = 0; i < barCount; i++) {
      final angle = i * angleStep;
      final barHeight = baseRadius * 0.6 * 
          (0.4 + 0.6 * math.sin((animation * 2 * math.pi) + (i * 0.5)));
      
      final startRadius = baseRadius * 1.2;
      final endRadius = startRadius + barHeight;

      final start = Offset(
        center.dx + startRadius * math.cos(angle),
        center.dy + startRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + endRadius * math.cos(angle),
        center.dy + endRadius * math.sin(angle),
      );

      final barPaint = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(start, end, barPaint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.state != state ||
        oldDelegate.color != color;
  }
}
