import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'generative_quantum_art.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';
import '../services/progress_service.dart';
import '../data/quantum_post.dart';
import '../theme/app_theme.dart';
import 'tasks/task_manager_dialog.dart';

class PostCard extends StatefulWidget {
  final QuantumPost post;
  final bool isActive;
  final VoidCallback? onNextMultiverse;

  const PostCard({
    super.key,
    required this.post,
    this.isActive = false,
    this.onNextMultiverse,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  bool _isVisible = false;
  bool _isUnlocked = false;
  bool _showSuccessBanner = false;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the underlying post is replaced (e.g. after "Next Multiverse"),
    // reset the card back to the locked/teaser state so the user sees
    // the fresh teaser on the main feed instead of the unlocked fact view.
    if (widget.post.id != oldWidget.post.id) {
      _isUnlocked = false;
      _showSuccessBanner = false;
      _isVisible = false;
      _bgController.stop();
      _entranceController.forward(from: 0);
    } else if (widget.isActive && !oldWidget.isActive) {
      _entranceController.forward(from: 0);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;

    final bool isVisible = info.visibleFraction >= 0.5;
    if (isVisible != _isVisible) {
      _isVisible = isVisible;

      if (_isVisible && !_isUnlocked) {
        _bgController.repeat();
        _entranceController.forward();
      } else {
        _bgController.stop();
      }
    }
  }

  void _handleUnlockFact() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, anim, secondaryAnim, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (context, anim, secondaryAnim) {
        return TaskManagerDialog(
          taskType: widget.post.taskType,
          onSuccess: () {
            Navigator.of(context).pop();
            _onTaskCompleted();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _onTaskCompleted() {
    HapticFeedback.heavyImpact();

    if (mounted) {
      context.read<ProgressService>().addInsightPoints(2);
    }

    setState(() {
      _isUnlocked = true;
      _showSuccessBanner = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSuccessBanner = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.post.id),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Stack(
        children: [
          // Background generative art
          Positioned.fill(
            child: GenerativeQuantumArt(
              seed: widget.post.id,
              animation: _bgController,
              isUnlocked: _isUnlocked,
            ),
          ),

          // Main content with entrance animation
          FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideUp,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 600),
                        crossFadeState: _isUnlocked
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Center(
                          child: Text(
                            widget.post.teaserText,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        secondChild: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 0.85, 0.95, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 8),
                                // Category tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.neonPurple.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.3)),
                                  ),
                                  child: const Text(
                                    '✦ QUANTUM FACT',
                                    style: TextStyle(
                                      color: AppTheme.neonPurple,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Teaser as subtitle
                                Text(
                                  widget.post.teaserText,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 40,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.neonBlue.withValues(alpha: 0.0),
                                        AppTheme.neonBlue,
                                        AppTheme.neonBlue.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                // Full fact — scrollable multi-paragraph content
                                Text(
                                  widget.post.fullFactText,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.neonBlue,
                                    height: 1.6,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (!_isUnlocked)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale = 1.0 + _pulseController.value * 0.04;
                              final glowAlpha = 0.3 + _pulseController.value * 0.4;
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.neonBlue.withValues(alpha: glowAlpha),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: ElevatedButton.icon(
                              onPressed: _handleUnlockFact,
                              icon: const Icon(Icons.lock_open, color: Colors.white),
                              label: const Text(
                                "Unlock Fact",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.neonBlue.withValues(alpha: 0.8),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: AppTheme.neonBlue,
                              ),
                            ),
                          ),
                        ),
                      ),

                    if (_isUnlocked)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale = 1.0 + _pulseController.value * 0.04;
                              final glowAlpha = 0.3 + _pulseController.value * 0.4;
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.neonPurple.withValues(alpha: glowAlpha),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: ElevatedButton.icon(
                              onPressed: widget.onNextMultiverse,
                              icon: const Icon(Icons.rocket_launch, color: Colors.white),
                              label: const Text(
                                'Next Multiverse',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.neonPurple.withValues(alpha: 0.8),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: AppTheme.neonPurple,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Success Banner Overlay
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedSlide(
                offset: _showSuccessBanner ? const Offset(0, 0) : const Offset(0, -1.5),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showSuccessBanner ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.only(top: 60),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.greenAccent),
                        SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantum Fact Unlocked!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "+2 Insight Points",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
