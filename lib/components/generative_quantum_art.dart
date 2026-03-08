import 'dart:math';
import 'package:flutter/material.dart';

class GenerativeQuantumArt extends StatelessWidget {
  final String seed;
  final Animation<double> animation;
  final bool isUnlocked;

  const GenerativeQuantumArt({
    super.key,
    required this.seed,
    required this.animation,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _QuantumPainter(
            seed: seed,
            progress: animation.value,
            isUnlocked: isUnlocked,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _QuantumLayerData {
  final int type;
  final Color baseColor;
  final double strokeWidth;
  final double radius;
  final double amplitude;
  final double frequency;
  final int numParticles;
  final List<double> particleAngles;
  final List<double> particleDistances;
  final List<double> particleSizes;

  _QuantumLayerData({
    required this.type,
    required this.baseColor,
    required this.strokeWidth,
    required this.radius,
    this.amplitude = 0.0,
    this.frequency = 0.0,
    this.numParticles = 0,
    this.particleAngles = const [],
    this.particleDistances = const [],
    this.particleSizes = const [],
  });
}

class _QuantumPainter extends CustomPainter {
  final String seed;
  final double progress;
  final bool isUnlocked;
  
  late final List<_QuantumLayerData> _layers;

  _QuantumPainter({
    required this.seed,
    required this.progress,
    required this.isUnlocked,
  }) {
    // Generate a consistent hash from the seed string to build layers once
    int hash = seed.hashCode;
    final rand = Random(hash);
    
    final int numLayers = rand.nextInt(3) + 3; // 3 to 5 layers
    _layers = List.generate(numLayers, (index) {
      final int type = rand.nextInt(3);
      final Color baseColor = _getRandomNeonColor(rand);
      final double strokeWidth = rand.nextDouble() * 3 + 1.0;
      // We don't have accurate size yet, so we'll store a multiplier & offset 
      // instead of absolute radius if we want to scale perfectly, 
      // but for simplicity we'll just precalculate the offset part
      // and compute the final radius in paint based on canvas size
      final double radiusOffset = rand.nextDouble() * 100;
      
      double amplitude = 0.0;
      double frequency = 0.0;
      int numParticles = 0;
      List<double> pAngles = [];
      List<double> pDists = [];
      List<double> pSizes = [];
      
      if (type == 0) {
        amplitude = 20 + rand.nextDouble() * 50;
        frequency = 1 + rand.nextDouble() * 4;
      } else if (type == 2) {
        numParticles = rand.nextInt(20) + 10;
        pAngles = List.generate(numParticles, (_) => rand.nextDouble() * 2 * pi);
        // store dist as a percentage 0..1 to scale later
        pDists = List.generate(numParticles, (_) => rand.nextDouble());
        pSizes = List.generate(numParticles, (_) => rand.nextDouble() * 4 + 1);
      }
      
      return _QuantumLayerData(
        type: type,
        baseColor: baseColor,
        strokeWidth: strokeWidth,
        radius: radiusOffset,
        amplitude: amplitude,
        frequency: frequency,
        numParticles: numParticles,
        particleAngles: pAngles,
        particleDistances: pDists,
        particleSizes: pSizes,
      );
    });
  }

  Color _getRandomNeonColor(Random rand) {
    switch (rand.nextInt(5)) {
      case 0: return const Color(0xFF00FFFF); // Cyan
      case 1: return const Color(0xFFFF00FF); // Magenta
      case 2: return const Color(0xFF39FF14); // Neon Green
      case 3: return const Color(0xFFFF3131); // Neon Red
      default: return const Color(0xFFFFFF00); // Neon Yellow
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final Offset center = Offset(cx, cy);

    final double opacityBase = isUnlocked ? 0.2 : 0.8;
    final double baseRadius = min(size.width, size.height) * 0.3;

    for (int i = 0; i < _layers.length; i++) {
      _drawQuantumLayer(canvas, size, center, i, _layers[i], baseRadius, opacityBase);
    }
  }

  void _drawQuantumLayer(
    Canvas canvas, 
    Size size, 
    Offset center, 
    int index, 
    _QuantumLayerData layer,
    double baseRadius,
    double opacityBase
  ) {
    final Color color = layer.baseColor.withValues(alpha: opacityBase);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = layer.strokeWidth;

    // Use progress to animate. We derive a consistent direction per layer index
    final double direction = (index % 2 == 0) ? 1.0 : -1.0;
    final double phase = progress * 2 * pi * direction;
    final double radius = baseRadius + layer.radius;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate((index * pi / 4) + (progress * pi));

    if (layer.type == 0) {
      // Wave form
      final Path path = Path();
      final double width = size.width;
      
      path.moveTo(-width / 2, 0);
      for (double x = -width / 2; x <= width / 2; x += 5) {
        double y = sin((x / width) * pi * layer.frequency + phase) * layer.amplitude;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    } else if (layer.type == 1) {
      // Orbital ring
      canvas.scale(1.0, 0.5); // Fixed scale instead of random for stability
      canvas.drawCircle(Offset.zero, radius, paint);
    } else if (layer.type == 2) {
      // Particle field
      paint.style = PaintingStyle.fill;
      for (int p = 0; p < layer.numParticles; p++) {
        final double angle = layer.particleAngles[p] + phase;
        final double dist = layer.particleDistances[p] * radius;
        final double px = cos(angle) * dist;
        final double py = sin(angle) * dist;
        canvas.drawCircle(Offset(px, py), layer.particleSizes[p], paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QuantumPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isUnlocked != isUnlocked;
  }
}
