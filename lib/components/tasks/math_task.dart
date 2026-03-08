import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class MathTask extends StatefulWidget {
  final VoidCallback onSuccess;

  const MathTask({super.key, required this.onSuccess});

  @override
  State<MathTask> createState() => _MathTaskState();
}

class _MathTaskState extends State<MathTask> with SingleTickerProviderStateMixin {
  final Random _rand = Random();
  late int _a;
  late int _b;
  late int _correctAnswer;
  late List<int> _options;
  int? _selectedAnswer;
  bool _showCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateProblem();
  }

  void _generateProblem() {
    _a = _rand.nextInt(10) + 2;
    _b = _rand.nextInt(10) + 2;
    _correctAnswer = _a * _b;

    _options = [_correctAnswer];
    while (_options.length < 4) {
      int wrongAnswer = _correctAnswer + (_rand.nextInt(20) - 10);
      if (wrongAnswer > 0 && !_options.contains(wrongAnswer)) {
        _options.add(wrongAnswer);
      }
    }
    _options.shuffle(_rand);
    _selectedAnswer = null;
    _showCorrect = false;
  }

  void _checkAnswer(int selected) {
    if (_showCorrect) return; // Already animating

    if (selected == _correctAnswer) {
      HapticFeedback.mediumImpact();
      setState(() {
        _selectedAnswer = selected;
        _showCorrect = true;
      });
      // Brief green flash before completing
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) widget.onSuccess();
      });
    } else {
      HapticFeedback.vibrate();
      setState(() => _selectedAnswer = selected);

      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() => _generateProblem());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Quantum mismatch. Try again!'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.neonBlue.withValues(alpha: 0.15),
            ),
          ),
          child: Center(
            child: Text(
              "$_a × $_b = ?",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.neonBlue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _options.map((option) {
            final isSelected = _selectedAnswer == option;
            final isCorrectChoice = _showCorrect && option == _correctAnswer;
            final isWrongChoice = isSelected && !_showCorrect && _selectedAnswer != null;

            Color bgColor;
            Color borderColor;
            if (isCorrectChoice) {
              bgColor = Colors.greenAccent.withValues(alpha: 0.3);
              borderColor = Colors.greenAccent;
            } else if (isWrongChoice) {
              bgColor = Colors.redAccent.withValues(alpha: 0.3);
              borderColor = Colors.redAccent;
            } else {
              bgColor = AppTheme.neonBlue.withValues(alpha: 0.2);
              borderColor = AppTheme.neonBlue.withValues(alpha: 0.5);
            }

            return AnimatedScale(
              scale: isSelected ? 0.92 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: SizedBox(
                width: 120,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor, width: 1.5),
                    ),
                    elevation: isCorrectChoice ? 8 : 0,
                    shadowColor: isCorrectChoice ? Colors.greenAccent : Colors.transparent,
                  ),
                  child: Text(
                    option.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
