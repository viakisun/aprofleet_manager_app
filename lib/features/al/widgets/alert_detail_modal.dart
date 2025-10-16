import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/alert.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';

class AlertDetailModal extends StatefulWidget {
  final Alert alert;
  final VoidCallback onAcknowledge;
  final Function(int) onEscalate;
  final VoidCallback onResolve;
  final VoidCallback onCreateWorkOrder;

  const AlertDetailModal({
    super.key,
    required this.alert,
    required this.onAcknowledge,
    required this.onEscalate,
    required this.onResolve,
    required this.onCreateWorkOrder,
  });

  @override
  State<AlertDetailModal> createState() => _AlertDetailModalState();
}

class _AlertDetailModalState extends State<AlertDetailModal> {
  int? _selectedEscalationLevel;

  @override
  Widget build(BuildContext context) {
    final severityColor =
        AppConstants.alertColors[widget.alert.severity] ?? Colors.grey;
    final priorityColor =
        AppConstants.priorityColors[widget.alert.priority] ?? Colors.grey;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.alert.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: severityColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: severityColor.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.alert.severity.displayName,
                              style: TextStyle(
                                color: severityColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          PriorityIndicator(priority: widget.alert.priority),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.grey),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alert Info
                  _buildSection(
                    'ALERT INFORMATION',
                    [
                      _buildInfoRow('Alert ID', widget.alert.id),
                      _buildInfoRow('Code', widget.alert.code),
                      _buildInfoRow('State', widget.alert.state.displayName),
                      _buildInfoRow(
                          'Created',
                          DateFormat('MMM dd, yyyy HH:mm')
                              .format(widget.alert.createdAt)),
                      _buildInfoRow(
                          'Updated',
                          DateFormat('MMM dd, yyyy HH:mm')
                              .format(widget.alert.updatedAt)),
                      if (widget.alert.cartId != null)
                        _buildInfoRow('Cart ID', widget.alert.cartId!),
                      if (widget.alert.location != null)
                        _buildInfoRow('Location', widget.alert.location!),
                      if (widget.alert.escalationLevel != null)
                        _buildInfoRow('Escalation Level',
                            'L${widget.alert.escalationLevel}'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Message
                  _buildSection(
                    'MESSAGE',
                    [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.alert.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action History
                  if (widget.alert.actions != null &&
                      widget.alert.actions!.isNotEmpty) ...[
                    _buildSection(
                      'ACTION HISTORY',
                      widget.alert.actions!.map((action) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    action.type.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    DateFormat('HH:mm')
                                        .format(action.timestamp),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              if (action.userId != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'By: ${action.userId}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              if (action.note != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  action.note!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Escalation Ladder
                  _buildSection(
                    'ESCALATION LADDER',
                    [
                      _buildEscalationLadder(),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notes
                  if (widget.alert.notes != null &&
                      widget.alert.notes!.isNotEmpty) ...[
                    _buildSection(
                      'NOTES',
                      [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.alert.notes!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ActionButton(
                    text: 'Acknowledge',
                    onPressed: widget.alert.state == AlertState.triggered ||
                            widget.alert.state == AlertState.notified
                        ? widget.onAcknowledge
                        : null,
                    type: ActionButtonType.secondary,
                    icon: Icons.check,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton(
                    text: 'Escalate',
                    onPressed: widget.alert.state != AlertState.resolved
                        ? () => _showEscalationDialog()
                        : null,
                    type: ActionButtonType.secondary,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton(
                    text: 'Resolve',
                    onPressed: widget.alert.state != AlertState.resolved
                        ? widget.onResolve
                        : null,
                    type: ActionButtonType.primary,
                    icon: Icons.done,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEscalationLadder() {
    final currentLevel = widget.alert.escalationLevel ?? 0;

    return Column(
      children: List.generate(4, (index) {
        final level = index;
        final isCurrent = level == currentLevel;
        final isCompleted = level < currentLevel;
        final color = isCompleted
            ? Colors.green
            : isCurrent
                ? Colors.blue
                : Colors.grey;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          'L$level',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $level',
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getEscalationDescription(level),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
            ],
          ),
        );
      }),
    );
  }

  String _getEscalationDescription(int level) {
    switch (level) {
      case 0:
        return 'Self-service resolution';
      case 1:
        return 'Technician notification';
      case 2:
        return 'Manager escalation';
      case 3:
        return 'Executive escalation';
      default:
        return 'Unknown level';
    }
  }

  void _showEscalationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title:
            const Text('Escalate Alert', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            final level = index;
            final isCurrent = level == (widget.alert.escalationLevel ?? 0);
            final isCompleted = level < (widget.alert.escalationLevel ?? 0);

            return RadioListTile<int>(
              title: Text('Level $level',
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                _getEscalationDescription(level),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              value: level,
              groupValue: _selectedEscalationLevel,
              onChanged: isCurrent || isCompleted
                  ? null
                  : (value) {
                      setState(() {
                        _selectedEscalationLevel = value;
                      });
                    },
              activeColor: Colors.white,
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _selectedEscalationLevel != null
                ? () {
                    widget.onEscalate(_selectedEscalationLevel!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Close detail modal too
                  }
                : null,
            child: const Text('Escalate'),
          ),
        ],
      ),
    );
  }
}
