import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// A mini-game where the user taps on scrambled letter tiles to spell a
/// quantum-related word. Includes an undo button for the last letter.
class WordMatchTask extends StatefulWidget {
  final VoidCallback onSuccess;

  const WordMatchTask({super.key, required this.onSuccess});

  @override
  State<WordMatchTask> createState() => _WordMatchTaskState();
}

class _WordMatchTaskState extends State<WordMatchTask> {
  static const List<String> _wordPool = [
    'QUARK',
    'PHOTON',
    'SPIN',
    'WAVE',
    'ATOM',
    'BOSON',
    'LEPTON',
    'GLUON',
    'MUON',
    'FLUX',
  ];

  final Random _rand = Random();
  late String _targetWord;
  late List<String> _shuffledLetters;
  final List<String> _selected = [];
  final List<int> _selectedIndices = [];
  final Set<int> _usedIndices = {};

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    _targetWord = _wordPool[_rand.nextInt(_wordPool.length)];
    _shuffledLetters = _targetWord.split('')..shuffle(_rand);
    while (_shuffledLetters.join() == _targetWord && _targetWord.length > 1) {
      _shuffledLetters.shuffle(_rand);
    }
    _selected.clear();
    _selectedIndices.clear();
    _usedIndices.clear();
  }

  void _onLetterTap(int index) {
    if (_usedIndices.contains(index)) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selected.add(_shuffledLetters[index]);
      _selectedIndices.add(index);
      _usedIndices.add(index);
    });

    if (_selected.length == _targetWord.length) {
      if (_selected.join() == _targetWord) {
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) widget.onSuccess();
        });
      } else {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wrong order – try again!'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 1),
          ),
        );
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() {
              _selected.clear();
              _selectedIndices.clear();
              _usedIndices.clear();
              _shuffledLetters.shuffle(_rand);
              while (_shuffledLetters.join() == _targetWord && _targetWord.length > 1) {
                _shuffledLetters.shuffle(_rand);
              }
            });
          }
        });
      }
    }
  }

  void _undoLast() {
    if (_selected.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selected.removeLast();
      final lastIndex = _selectedIndices.removeLast();
      _usedIndices.remove(lastIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _selected.length == _targetWord.length && _selected.join() == _targetWord;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Spell the word:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 12),
        // Target word blanks
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_targetWord.length, (i) {
            final filled = i < _selected.length;
            final correct = isComplete;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: correct
                    ? Colors.greenAccent.withValues(alpha: 0.25)
                    : filled
                        ? AppTheme.neonBlue.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: correct
                      ? Colors.greenAccent
                      : filled
                          ? AppTheme.neonBlue
                          : Colors.white.withValues(alpha: 0.2),
                  width: correct ? 2 : 1,
                ),
                boxShadow: correct
                    ? [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.3), blurRadius: 8)]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                filled ? _selected[i] : '',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: correct ? Colors.greenAccent : Colors.white,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        // Undo button
        if (_selected.isNotEmpty && !isComplete)
          Center(
            child: TextButton.icon(
              onPressed: _undoLast,
              icon: Icon(Icons.undo, color: Colors.white.withValues(alpha: 0.6), size: 18),
              label: Text(
                'Undo',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            ),
          ),
        const SizedBox(height: 8),
        // Scrambled letter choices
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(_shuffledLetters.length, (index) {
            final used = _usedIndices.contains(index);
            return GestureDetector(
              onTap: used ? null : () => _onLetterTap(index),
              child: AnimatedScale(
                scale: used ? 0.85 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedOpacity(
                  opacity: used ? 0.25 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.neonPurple.withValues(alpha: used ? 0.1 : 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.neonPurple.withValues(alpha: used ? 0.2 : 0.6),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _shuffledLetters[index],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
