import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/common/cards/base_card.dart';
import '../../controllers/work_order_creation_controller.dart';
import '../technician_selector.dart';

/// Third step of work order creation: Schedule and Technician selection
class WorkOrderCreationStep3 extends ConsumerStatefulWidget {
  final WorkOrderCreationController controller;

  const WorkOrderCreationStep3({
    super.key,
    required this.controller,
  });

  @override
  ConsumerState<WorkOrderCreationStep3> createState() =>
      _WorkOrderCreationStep3State();
}

class _WorkOrderCreationStep3State
    extends ConsumerState<WorkOrderCreationStep3> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final createWoState = ref.watch(workOrderCreationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Schedule Section
          _buildSectionHeader('SCHEDULE'),
          const SizedBox(height: DesignTokens.spacingMd),

          // Date Selection
          BaseCard(
            onTap: _selectDate,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: DesignTokens.textPrimary,
                  size: DesignTokens.iconMd,
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: _selectedDate != null
                              ? DesignTokens.textPrimary
                              : DesignTokens.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: DesignTokens.textTertiary,
                  size: DesignTokens.iconSm,
                ),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Time Selection
          BaseCard(
            onTap: _selectTime,
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: DesignTokens.textPrimary,
                  size: DesignTokens.iconMd,
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select time',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: _selectedTime != null
                              ? DesignTokens.textPrimary
                              : DesignTokens.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: DesignTokens.textTertiary,
                  size: DesignTokens.iconSm,
                ),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Technician Section
          _buildSectionHeader('ASSIGN TECHNICIAN'),
          const SizedBox(height: DesignTokens.spacingMd),
          TechnicianSelector(
            selectedTechnician: createWoState.draft.technician,
            onTechnicianSelected: widget.controller.setTechnician,
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Estimated Duration Section
          _buildSectionHeader('ESTIMATED DURATION'),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final duration = int.tryParse(value);
                    if (duration != null) {
                      widget.controller
                          .setEstimatedDuration(Duration(hours: duration));
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Hours',
                    hintStyle: TextStyle(
                      color: DesignTokens.textTertiary,
                      fontSize: DesignTokens.fontSizeMd,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusSm),
                      borderSide: BorderSide(color: DesignTokens.borderPrimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusSm),
                      borderSide: BorderSide(color: DesignTokens.borderPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusSm),
                      borderSide:
                          const BorderSide(color: DesignTokens.textPrimary),
                    ),
                    contentPadding:
                        const EdgeInsets.all(DesignTokens.spacingMd),
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Text(
                'hours',
                style: TextStyle(
                  color: DesignTokens.textSecondary,
                  fontSize: DesignTokens.fontSizeMd,
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Notes Section
          _buildSectionHeader('NOTES'),
          const SizedBox(height: DesignTokens.spacingMd),
          TextField(
            onChanged: widget.controller.setNotes,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Additional notes or instructions...',
              hintStyle: TextStyle(
                color: DesignTokens.textTertiary,
                fontSize: DesignTokens.fontSizeMd,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                borderSide: BorderSide(color: DesignTokens.borderPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                borderSide: BorderSide(color: DesignTokens.borderPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                borderSide: const BorderSide(color: DesignTokens.textPrimary),
              ),
              contentPadding: const EdgeInsets.all(DesignTokens.spacingMd),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: DesignTokens.getUppercaseLabelStyle(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: DesignTokens.fontWeightSemibold,
        color: DesignTokens.textPrimary,
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // Update controller with combined date and time
      if (_selectedTime != null) {
        final scheduledAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        widget.controller.setScheduledAt(scheduledAt);
      }
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });

      // Update controller with combined date and time
      if (_selectedDate != null) {
        final scheduledAt = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          picked.hour,
          picked.minute,
        );
        widget.controller.setScheduledAt(scheduledAt);
      }
    }
  }
}
