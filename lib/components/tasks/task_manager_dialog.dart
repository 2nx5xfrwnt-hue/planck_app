import 'package:flutter/material.dart';
import '../../data/quantum_post.dart';
import 'math_task.dart';
import 'color_sequence_task.dart';
import 'word_match_task.dart';
import 'tap_target_task.dart';

class TaskManagerDialog extends StatelessWidget {
  final TaskType taskType;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const TaskManagerDialog({
    super.key,
    required this.taskType,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Proof of Observation",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCancel,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Complete this simple task to collapse the wave function and unlock the fact.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            _buildTaskContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskContent() {
    switch (taskType) {
      case TaskType.math:
        return MathTask(onSuccess: onSuccess);
      case TaskType.colorSequence:
        return ColorSequenceTask(onSuccess: onSuccess);
      case TaskType.wordMatch:
        return WordMatchTask(onSuccess: onSuccess);
      case TaskType.tapTarget:
        return TapTargetTask(onSuccess: onSuccess);
    }
  }
}
