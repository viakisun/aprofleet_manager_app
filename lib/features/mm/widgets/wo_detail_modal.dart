import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';

class WoDetailModal extends StatefulWidget {
  final WorkOrder workOrder;
  final Function(WorkOrder) onUpdate;

  const WoDetailModal({
    super.key,
    required this.workOrder,
    required this.onUpdate,
  });

  @override
  State<WoDetailModal> createState() => _WoDetailModalState();
}

class _WoDetailModalState extends State<WoDetailModal> {
  late WorkOrder _workOrder;
  late Map<String, bool> _checklist;
  WorkOrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _workOrder = widget.workOrder;
    _checklist = Map<String, bool>.from(_workOrder.checklist ?? {});
    _selectedStatus = _workOrder.status;
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor =
        AppConstants.priorityColors[_workOrder.priority] ?? Colors.grey;

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
                        _workOrder.id,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          PriorityIndicator(priority: _workOrder.priority),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_workOrder.status)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColor(_workOrder.status)
                                    .withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _workOrder.status.displayName,
                              style: TextStyle(
                                color: _getStatusColor(_workOrder.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
                  // Work Order Info
                  _buildSection(
                    'WORK ORDER INFO',
                    [
                      _buildInfoRow('Type', _workOrder.type.displayName),
                      _buildInfoRow('Description', _workOrder.description),
                      _buildInfoRow('Cart ID', _workOrder.cartId),
                      if (_workOrder.location != null)
                        _buildInfoRow('Location', _workOrder.location!),
                      _buildInfoRow(
                          'Created',
                          DateFormat('MMM dd, yyyy HH:mm')
                              .format(_workOrder.createdAt)),
                      if (_workOrder.technician != null)
                        _buildInfoRow('Technician', _workOrder.technician!),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Status Update
                  _buildSection(
                    'STATUS UPDATE',
                    [
                      DropdownButtonFormField<WorkOrderStatus>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        dropdownColor: const Color(0xFF1A1A1A),
                        style: const TextStyle(color: Colors.white),
                        items: WorkOrderStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.displayName),
                          );
                        }).toList(),
                        onChanged: (status) {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Checklist
                  if (_checklist.isNotEmpty) ...[
                    _buildSection(
                      'CHECKLIST',
                      _checklist.entries.map((entry) {
                        return CheckboxListTile(
                          title: Text(
                            entry.key.replaceAll('_', ' ').toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: entry.value,
                          onChanged: (value) {
                            setState(() {
                              _checklist[entry.key] = value ?? false;
                            });
                          },
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Parts
                  if (_workOrder.parts != null &&
                      _workOrder.parts!.isNotEmpty) ...[
                    _buildSection(
                      'PARTS USED',
                      _workOrder.parts!.map((part) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      part.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Qty: ${part.quantity}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (part.serialNumber != null)
                                      Text(
                                        'SN: ${part.serialNumber}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Notes
                  if (_workOrder.notes != null &&
                      _workOrder.notes!.isNotEmpty) ...[
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
                            _workOrder.notes!,
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
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    type: ActionButtonType.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    text: 'Update Status',
                    onPressed: _canUpdateStatus() ? _updateStatus : null,
                    type: ActionButtonType.primary,
                  ),
                ),
                if (_workOrder.status == WorkOrderStatus.inProgress) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ActionButton(
                      text: 'Mark Complete',
                      onPressed: _canMarkComplete() ? _markComplete : null,
                      type: ActionButtonType.primary,
                    ),
                  ),
                ],
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
            width: 100,
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

  bool _canUpdateStatus() {
    return _selectedStatus != null && _selectedStatus != _workOrder.status;
  }

  bool _canMarkComplete() {
    if (_workOrder.status != WorkOrderStatus.inProgress) return false;

    // Check if all mandatory checklist items are completed
    final mandatoryItems = _checklist.entries
        .where((entry) =>
            entry.key.contains('mandatory') || entry.key.contains('required'))
        .toList();

    if (mandatoryItems.isNotEmpty) {
      return mandatoryItems.every((item) => item.value);
    }

    return true;
  }

  void _updateStatus() {
    if (_selectedStatus != null) {
      final updatedWorkOrder = _workOrder.copyWith(
        status: _selectedStatus!,
        checklist: _checklist,
      );
      widget.onUpdate(updatedWorkOrder);
      Navigator.of(context).pop();
    }
  }

  void _markComplete() {
    final updatedWorkOrder = _workOrder.copyWith(
      status: WorkOrderStatus.completed,
      completedAt: DateTime.now(),
      checklist: _checklist,
    );
    widget.onUpdate(updatedWorkOrder);
    Navigator.of(context).pop();
  }

  Color _getStatusColor(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.draft:
        return Colors.grey;
      case WorkOrderStatus.pending:
        return Colors.orange;
      case WorkOrderStatus.inProgress:
        return Colors.blue;
      case WorkOrderStatus.onHold:
        return Colors.purple;
      case WorkOrderStatus.completed:
        return Colors.green;
      case WorkOrderStatus.cancelled:
        return Colors.red;
    }
  }
}
