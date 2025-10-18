import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

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
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REGISTRATION PROGRESS',
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: DesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
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
        ? DesignTokens.statusActive
        : DesignTokens.textTertiary;

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
                      ? DesignTokens.statusActive
                      : isCurrent
                          ? DesignTokens.statusActive.withValues(alpha: 0.2)
                          : DesignTokens.bgTertiary,
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
                          size: DesignTokens.iconSm,
                          color: DesignTokens.bgPrimary,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            fontWeight: DesignTokens.fontWeightSemibold,
                            color: stepColor,
                          ),
                        ),
                ),
              ),
              if (!isLast) ...[
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? DesignTokens.statusActive
                          : DesignTokens.borderPrimary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
              ],
            ],
          ),

          const SizedBox(height: DesignTokens.spacingSm),

          // Step info
          Column(
            children: [
              Text(
                step.title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXs,
                  fontWeight: isCurrent
                      ? DesignTokens.fontWeightSemibold
                      : DesignTokens.fontWeightMedium,
                  color: stepColor,
                  letterSpacing: DesignTokens.letterSpacingWide,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (step.description.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXs,
                    color: DesignTokens.textTertiary,
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
