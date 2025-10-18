import 'package:flutter/material.dart';

class Stepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;
  final Function(int)? onStepTap;

  const Stepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          final isLast = index == totalSteps - 1;

          return Expanded(
            child: Row(
              children: [
                // Step Circle
                GestureDetector(
                  onTap: onStepTap != null ? () => onStepTap!(index) : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green
                          : isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? Colors.green
                            : isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.black : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                // Step Title
                if (index < stepTitles.length) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stepTitles[index],
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                // Connector Line
                if (!isLast) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
