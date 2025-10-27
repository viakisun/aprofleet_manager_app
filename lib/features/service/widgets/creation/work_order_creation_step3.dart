import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../../core/widgets/via/via_card.dart';
import '../../../../core/widgets/via/via_input.dart';
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
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Schedule Section
          _buildSectionHeader('SCHEDULE'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          // Date Selection
          ViaCard(
            onTap: _selectDate,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: IndustrialDarkTokens.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingItem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                      Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select date',
                        style: TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeLabel,
                          fontWeight: IndustrialDarkTokens.fontWeightBold,
                          color: _selectedDate != null
                              ? IndustrialDarkTokens.textPrimary
                              : IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: IndustrialDarkTokens.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          // Time Selection
          ViaCard(
            onTap: _selectTime,
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: IndustrialDarkTokens.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingItem),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                      Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select time',
                        style: TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeLabel,
                          fontWeight: IndustrialDarkTokens.fontWeightBold,
                          color: _selectedTime != null
                              ? IndustrialDarkTokens.textPrimary
                              : IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: IndustrialDarkTokens.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Technician Section
          _buildSectionHeader('ASSIGN TECHNICIAN'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          TechnicianSelector(
            selectedTechnician: createWoState.draft.technician,
            onTechnicianSelected: widget.controller.setTechnician,
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Estimated Duration Section
          _buildSectionHeader('ESTIMATED DURATION'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          Row(
            children: [
              Expanded(
                child: ViaInput(
                  inputType: ViaInputType.number,
                  label: 'Duration',
                  placeholder: 'Hours',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final duration = int.tryParse(value);
                    if (duration != null) {
                      widget.controller
                          .setEstimatedDuration(Duration(hours: duration));
                    }
                  },
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingItem),
              const Text(
                'hours',
                style: TextStyle(
                  color: IndustrialDarkTokens.textSecondary,
                  fontSize: IndustrialDarkTokens.fontSizeLabel,
                ),
              ),
            ],
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Notes Section
          _buildSectionHeader('NOTES'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          ViaInput(
            onChanged: widget.controller.setNotes,
            label: 'Notes',
            placeholder: 'Additional notes or instructions...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: IndustrialDarkTokens.getUppercaseLabelStyle(
        fontSize: IndustrialDarkTokens.fontSizeSmall,
        fontWeight: IndustrialDarkTokens.fontWeightBold,
        color: IndustrialDarkTokens.textPrimary,
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
