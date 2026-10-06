import 'package:flutter/material.dart';

class ProgressCue extends StatelessWidget {
  final int currentStep; // 1: Browse, 2: Details, 3: Sign up, 4: Confirm

  const ProgressCue({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Browse', 'Details', 'Sign up', 'Confirm'];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Separator
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 32,
              height: 2,
              color: theme.colorScheme.outline,
            );
          }
          final stepIndex = index ~/ 2 + 1;
          final isActive = stepIndex == currentStep;
          final isPast = stepIndex < currentStep;

          return Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive || isPast ? theme.colorScheme.primary : theme.colorScheme.surface,
                  border: Border.all(
                    color: isActive || isPast ? theme.colorScheme.primary : theme.colorScheme.outline,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isPast
                      ? Icon(
                          Icons.check, 
                          size: 14, 
                          color: theme.colorScheme.onPrimary
                        )
                      : Text(
                          '$stepIndex',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isActive 
                              ? theme.colorScheme.onPrimary 
                              : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                steps[stepIndex - 1],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive || isPast ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
