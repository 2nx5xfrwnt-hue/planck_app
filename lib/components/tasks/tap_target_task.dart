import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// A mini-game where glowing "quantum particles" appear at random positions
/// and the user must tap them before they fade out. Tap enough to succeed.
class TapTargetTask extends StatefulWidget {
  final VoidCallback onSuccess;

  const TapTargetTask({super.key, required this.onSuccess});

  @override
  State<TapTargetTask> createState() => _TapTargetTaskState();
}

class _TapTargetTaskState extends State<TapTargetTask>
    with TickerProviderStateMixin {
  static const int _requiredHits = 5;
  final Random _rand = Random();

  int _hits = 0;
  double _targetX = 0.5;
  double _targetY = 0.5;
  late AnimationController _pulseController;
  late AnimationController _burstController;
  double _burstX = 0;
  double _burstY = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _moveTarget();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  void _moveTarget() {
    setState(() {
      _targetX = 0.1 + _rand.nextDouble() * 0.8;
      _targetY = 0.1 + _rand.nextDouble() * 0.8;
    });
  }

  void _onHit(double tapX, double tapY) {
    HapticFeedback.lightImpact();

    // Trigger burst at tap location
    _burstX = tapX;
    _burstY = tapY;
    _burstController.forward(from: 0);

    _hits++;
    if (_hits >= _requiredHits) {
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) widget.onSuccess();
      });
    } else {
      _moveTarget();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Catch $_requiredHits quantum particles!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 8),
        // Progress dots with animation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_requiredHits, (i) {
            final caught = i < _hits;
            return AnimatedScale(
              scale: caught ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 14,
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: caught
                      ? AppTheme.neonBlue
                      : Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppTheme.neonBlue.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: caught
                      ? [BoxShadow(color: AppTheme.neonBlue.withValues(alpha: 0.5), blurRadius: 8)]
                      : [],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Hit counter
        Text(
          '$_hits/$_requiredHits caught',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.neonBlue.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        // Play area
        SizedBox(
          height: 220,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final areaW = constraints.maxWidth;
              final areaH = constraints.maxHeight;
              const targetSize = 56.0;

              return Stack(
                children: [
                  // Background grid effect
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  // Target particle
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    left: (_targetX * (areaW - targetSize)).clamp(0, areaW - targetSize),
                    top: (_targetY * (areaH - targetSize)).clamp(0, areaH - targetSize),
                    child: GestureDetector(
                      onTapDown: (details) {
                        final pos = details.globalPosition;
                        final box = context.findRenderObject() as RenderBox;
                        final local = box.globalToLocal(pos);
                        _onHit(local.dx, local.dy);
                      },
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = 1.0 + _pulseController.value * 0.2;
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: Container(
                          width: targetSize,
                          height: targetSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                AppTheme.neonBlue,
                                AppTheme.neonPurple,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonBlue.withValues(alpha: 0.6),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.blur_on,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Burst particles
                  AnimatedBuilder(
                    animation: _burstController,
                    builder: (context, _) {
                      if (!_burstController.isAnimating && _burstController.value == 0) {
                        return const SizedBox.shrink();
                      }
                      final progress = _burstController.value;
                      final opacity = (1.0 - progress).clamp(0.0, 1.0);
                      return CustomPaint(
                        size: Size(areaW, areaH),
                        painter: _BurstPainter(
                          centerX: _burstX,
                          centerY: _burstY,
                          progress: progress,
                          opacity: opacity,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Paints a small radial burst of particles emanating from tap location.
class _BurstPainter extends CustomPainter {
  final double centerX;
  final double centerY;
  final double progress;
  final double opacity;
  static const int _particleCount = 8;

  _BurstPainter({
    required this.centerX,
    required this.centerY,
    required this.progress,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.neonBlue.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.fill;

    final radius = 30.0 * progress;
    for (int i = 0; i < _particleCount; i++) {
      final angle = (i / _particleCount) * 2 * pi;
      final dx = centerX + cos(angle) * radius;
      final dy = centerY + sin(angle) * radius;
      final dotSize = 3.0 * (1 - progress);
      canvas.drawCircle(Offset(dx, dy), dotSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
