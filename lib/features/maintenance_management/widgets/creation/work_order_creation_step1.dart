import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/via/via_input.dart';
import '../../controllers/work_order_creation_controller.dart';
import '../work_order_type_selector.dart';
import '../priority_selector.dart';

/// First step of work order creation: Type and Priority selection
class WorkOrderCreationStep1 extends ConsumerWidget {
  final WorkOrderCreationController controller;

  const WorkOrderCreationStep1({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createWoState = ref.watch(workOrderCreationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Work Order Type Section
          _buildSectionHeader('WORK ORDER TYPE'),
          const SizedBox(height: DesignTokens.spacingMd),
          WorkOrderTypeSelector(
            selectedType: createWoState.draft.type,
            onTypeSelected: (type) {
              controller.setWorkOrderType(type);
            },
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Priority Section
          _buildSectionHeader('PRIORITY'),
          const SizedBox(height: DesignTokens.spacingMd),
          PrioritySelector(
            selectedPriority: createWoState.draft.priority,
            onPrioritySelected: controller.setPriority,
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Description Section
          _buildSectionHeader('DESCRIPTION'),
          const SizedBox(height: DesignTokens.spacingMd),
          ViaInput(
            initialValue: createWoState.draft.description,
            onChanged: controller.setDescription,
            label: 'Description',
            placeholder: 'Describe the work to be performed...',
            maxLines: 4,
            validator: (value) {
              if (value == null || value.length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
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
}
