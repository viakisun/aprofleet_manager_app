import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class EscalationStep {
  final String id;
  final String title;
  final String description;
  final DateTime? completedAt;
  final String? assignedTo;
  final EscalationStatus status;

  const EscalationStep({
    required this.id,
    required this.title,
    required this.description,
    this.completedAt,
    this.assignedTo,
    required this.status,
  });
}

enum EscalationStatus {
  pending,
  inProgress,
  completed,
  skipped,
}

class EscalationPath extends StatelessWidget {
  final List<EscalationStep> steps;

  const EscalationPath({
    super.key,
    required this.steps,
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
          Row(
            children: [
              const Icon(
                Icons.timeline,
                size: DesignTokens.iconMd,
                color: DesignTokens.textPrimary,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text(
                'ESCALATION PATH',
                style: DesignTokens.getUppercaseLabelStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightSemibold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const Spacer(),
              // SLA indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: DesignTokens.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.statusWarning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: const Text(
                  'SLA: 2H',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXs,
                    fontWeight: DesignTokens.fontWeightSemibold,
                    color: DesignTokens.statusWarning,
                    letterSpacing: DesignTokens.letterSpacingWide,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return _buildStepItem(step, isLast, index);
          }),
        ],
      ),
    );
  }

  Widget _buildStepItem(EscalationStep step, bool isLast, int index) {
    final statusColor = _getStatusColor(step.status);
    final statusIcon = _getStatusIcon(step.status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor,
                  width: 2,
                ),
              ),
              child: Icon(
                statusIcon,
                size: 12,
                color: statusColor,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                margin: const EdgeInsets.only(top: DesignTokens.spacingXs),
                decoration: BoxDecoration(
                  color: DesignTokens.borderPrimary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),

        const SizedBox(width: DesignTokens.spacingMd),

        // Step content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              bottom: isLast ? 0 : DesignTokens.spacingMd,
            ),
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: step.status == EscalationStatus.inProgress
                  ? statusColor.withValues(alpha: 0.1)
                  : DesignTokens.bgTertiary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              border: Border.all(
                color: step.status == EscalationStatus.inProgress
                    ? statusColor.withValues(alpha: 0.3)
                    : DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        step.title,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                      child: Text(
                        step.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXs,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: statusColor,
                          letterSpacing: DesignTokens.letterSpacingWide,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DesignTokens.spacingXs),

                // Step description
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondary,
                  ),
                ),

                // Assignment and completion info
                if (step.assignedTo != null || step.completedAt != null) ...[
                  const SizedBox(height: DesignTokens.spacingSm),
                  Row(
                    children: [
                      if (step.assignedTo != null) ...[
                        Icon(
                          Icons.person,
                          size: DesignTokens.iconSm,
                          color: DesignTokens.textTertiary,
                        ),
                        const SizedBox(width: DesignTokens.spacingXs),
                        Text(
                          step.assignedTo!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXs,
                            color: DesignTokens.textTertiary,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (step.completedAt != null) ...[
                        Icon(
                          Icons.schedule,
                          size: DesignTokens.iconSm,
                          color: DesignTokens.textTertiary,
                        ),
                        const SizedBox(width: DesignTokens.spacingXs),
                        Text(
                          _formatDateTime(step.completedAt!),
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXs,
                            color: DesignTokens.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(EscalationStatus status) {
    switch (status) {
      case EscalationStatus.pending:
        return DesignTokens.textSecondary;
      case EscalationStatus.inProgress:
        return DesignTokens.statusCharging;
      case EscalationStatus.completed:
        return DesignTokens.alertSuccess;
      case EscalationStatus.skipped:
        return DesignTokens.statusOffline;
    }
  }

  IconData _getStatusIcon(EscalationStatus status) {
    switch (status) {
      case EscalationStatus.pending:
        return Icons.schedule;
      case EscalationStatus.inProgress:
        return Icons.play_arrow;
      case EscalationStatus.completed:
        return Icons.check;
      case EscalationStatus.skipped:
        return Icons.skip_next;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// Mock data generator
class EscalationPathBuilder {
  static List<EscalationStep> buildMockPath() {
    return [
      EscalationStep(
        id: 'step-1',
        title: 'Auto-Notification',
        description: 'System automatically notifies assigned technician',
        completedAt: DateTime(2024, 1, 15, 10, 30),
        assignedTo: 'System',
        status: EscalationStatus.completed,
      ),
      const EscalationStep(
        id: 'step-2',
        title: 'Technician Assignment',
        description: 'Alert assigned to primary technician for resolution',
        assignedTo: 'John Smith',
        status: EscalationStatus.inProgress,
      ),
      const EscalationStep(
        id: 'step-3',
        title: 'Supervisor Escalation',
        description: 'Escalate to maintenance supervisor if not resolved',
        assignedTo: 'Sarah Johnson',
        status: EscalationStatus.pending,
      ),
      const EscalationStep(
        id: 'step-4',
        title: 'Manager Escalation',
        description: 'Final escalation to fleet manager',
        assignedTo: 'Mike Chen',
        status: EscalationStatus.pending,
      ),
    ];
  }
}
