import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AmbientParticles extends StatefulWidget {
  final int particleCount;

  const AmbientParticles({super.key, this.particleCount = 50});

  @override
  State<AmbientParticles> createState() => _AmbientParticlesState();
}

class _AmbientParticlesState extends State<AmbientParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
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
        final value = _controller.value * 2 * pi;
        return CustomPaint(
          painter: _ParticlePainter(value, widget.particleCount),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;
  final int count;
  final Random random = Random(42); // Fixed seed for stable particle positions

  _ParticlePainter(this.animationValue, this.count);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.neonBlue.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;

      final speedMultiplier = random.nextDouble() * 0.5 + 0.5;
      final phaseOffset = random.nextDouble() * 2 * pi;

      final dx = sin(animationValue * speedMultiplier + phaseOffset) * 20;
      final dy = cos(animationValue * speedMultiplier * 0.8 + phaseOffset) * 20;

      canvas.drawCircle(Offset(startX + dx, startY + dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
