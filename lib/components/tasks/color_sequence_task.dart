import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// A Simon-says style memory game. A sequence of colored orbs flash in order;
/// the user must tap them back in the same order to succeed.
class ColorSequenceTask extends StatefulWidget {
  final VoidCallback onSuccess;

  const ColorSequenceTask({super.key, required this.onSuccess});

  @override
  State<ColorSequenceTask> createState() => _ColorSequenceTaskState();
}

class _ColorSequenceTaskState extends State<ColorSequenceTask>
    with SingleTickerProviderStateMixin {
  static const int _sequenceLength = 4;
  static const List<Color> _palette = [
    Color(0xFF00F0FF), // neonBlue
    Color(0xFFB026FF), // neonPurple
    Color(0xFF00FF88), // green
    Color(0xFFFF4081), // pink
  ];

  final Random _rand = Random();
  late List<int> _sequence;
  List<int> _playerInput = [];
  int _highlightIndex = -1;
  bool _isShowingSequence = true;
  bool _wrong = false;
  int _round = 1;
  static const int _maxRounds = 2;

  @override
  void initState() {
    super.initState();
    _generateSequence();
    _playSequence();
  }

  void _generateSequence() {
    _sequence = List.generate(_sequenceLength, (_) => _rand.nextInt(_palette.length));
    _playerInput = [];
    _wrong = false;
  }

  Future<void> _playSequence() async {
    setState(() => _isShowingSequence = true);
    await Future.delayed(const Duration(milliseconds: 400));

    for (int i = 0; i < _sequence.length; i++) {
      if (!mounted) return;
      setState(() => _highlightIndex = _sequence[i]);
      HapticFeedback.selectionClick();
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _highlightIndex = -1);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (mounted) {
      setState(() => _isShowingSequence = false);
    }
  }

  void _onOrbTap(int index) {
    if (_isShowingSequence) return;

    HapticFeedback.lightImpact();
    setState(() {
      _highlightIndex = index;
      _playerInput.add(index);
    });

    // Brief flash
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _highlightIndex = -1);
    });

    final step = _playerInput.length - 1;
    if (_playerInput[step] != _sequence[step]) {
      // Wrong!
      HapticFeedback.vibrate();
      setState(() => _wrong = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wrong sequence – watch again!'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 1),
        ),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _playerInput = [];
            _wrong = false;
          });
          _playSequence();
        }
      });
      return;
    }

    if (_playerInput.length == _sequence.length) {
      // Round complete!
      if (_round >= _maxRounds) {
        // All rounds done — success!
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) widget.onSuccess();
        });
      } else {
        // Next round with new sequence
        HapticFeedback.mediumImpact();
        setState(() => _round++);
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _generateSequence();
            _playSequence();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Round indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isShowingSequence ? 'Watch the sequence…' : 'Repeat the pattern!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            if (_maxRounds > 1) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.neonPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$_round/$_maxRounds',
                  style: const TextStyle(
                    color: AppTheme.neonPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Progress indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_sequenceLength, (i) {
            final done = i < _playerInput.length;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? (_wrong ? Colors.redAccent : AppTheme.neonBlue)
                    : Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: AppTheme.neonBlue.withValues(alpha: 0.4),
                ),
                boxShadow: done && !_wrong
                    ? [BoxShadow(color: AppTheme.neonBlue.withValues(alpha: 0.4), blurRadius: 6)]
                    : [],
              ),
            );
          }),
        ),
        const SizedBox(height: 28),
        // 4 orb buttons in a 2×2 grid
        Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(_palette.length, (i) {
                final isLit = _highlightIndex == i;
                final color = _palette[i];
                return GestureDetector(
                  onTap: _isShowingSequence ? null : () => _onOrbTap(i),
                  child: AnimatedScale(
                    scale: isLit ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLit
                            ? color.withValues(alpha: 0.9)
                            : color.withValues(alpha: 0.2),
                        border: Border.all(
                          color: color.withValues(alpha: isLit ? 1.0 : 0.45),
                          width: 2.5,
                        ),
                        boxShadow: isLit
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.7),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
