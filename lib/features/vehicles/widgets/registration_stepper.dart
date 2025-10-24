import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

class RegistrationStepper extends StatelessWidget {
  final int currentStep;
  final List<RegistrationStep> steps;
  final Function(int)? onStepTap;

  const RegistrationStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
      decoration: BoxDecoration(
        color: IndustrialDarkTokens.bgSurface,
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
        border: Border.all(
          color: IndustrialDarkTokens.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REGISTRATION PROGRESS',
            style: IndustrialDarkTokens.getUppercaseLabelStyle(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isPending = index > currentStep;

              return Expanded(
                child: _buildStepItem(
                  step: step,
                  index: index,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                  isPending: isPending,
                  isLast: index == steps.length - 1,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required RegistrationStep step,
    required int index,
    required bool isCompleted,
    required bool isCurrent,
    required bool isPending,
    required bool isLast,
  }) {
    final stepColor = isCompleted || isCurrent
        ? IndustrialDarkTokens.statusActive
        : IndustrialDarkTokens.textSecondary;

    return GestureDetector(
      onTap: onStepTap != null && (isCompleted || isCurrent)
          ? () => onStepTap!(index)
          : null,
      child: Column(
        children: [
          // Step indicator
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? IndustrialDarkTokens.statusActive
                      : isCurrent
                          ? IndustrialDarkTokens.statusActive.withValues(alpha: 0.2)
                          : IndustrialDarkTokens.bgSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: stepColor,
                    width: isCurrent ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: IndustrialDarkTokens.bgBase,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: IndustrialDarkTokens.fontSizeSmall,
                            fontWeight: IndustrialDarkTokens.fontWeightBold,
                            color: stepColor,
                          ),
                        ),
                ),
              ),
              if (!isLast) ...[
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? IndustrialDarkTokens.statusActive
                          : IndustrialDarkTokens.outline,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              ],
            ],
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCompact),

          // Step info
          Column(
            children: [
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isCurrent
                      ? IndustrialDarkTokens.fontWeightBold
                      : IndustrialDarkTokens.fontWeightMedium,
                  color: stepColor,
                  letterSpacing: IndustrialDarkTokens.letterSpacing,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (step.description.isNotEmpty) ...[
                const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class RegistrationStep {
  final String title;
  final String description;
  final IconData? icon;

  const RegistrationStep({
    required this.title,
    this.description = '',
    this.icon,
  });
}

class RegistrationStepperBuilder {
  static List<RegistrationStep> buildCartRegistrationSteps() {
    return const [
      RegistrationStep(
        title: 'BASIC INFO',
        description: 'Cart details & specifications',
        icon: Icons.info_outline,
      ),
      RegistrationStep(
        title: 'COMPONENTS',
        description: 'Parts & system checklist',
        icon: Icons.checklist,
      ),
      RegistrationStep(
        title: 'DOCUMENTATION',
        description: 'Photos & documents',
        icon: Icons.photo_camera,
      ),
      RegistrationStep(
        title: 'CONFIRMATION',
        description: 'Review & submit',
        icon: Icons.check_circle,
      ),
    ];
  }
}
