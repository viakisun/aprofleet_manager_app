import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
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
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Work Order Type Section
          _buildSectionHeader('WORK ORDER TYPE'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          WorkOrderTypeSelector(
            selectedType: createWoState.draft.type,
            onTypeSelected: (type) {
              controller.setWorkOrderType(type);
            },
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Priority Section
          _buildSectionHeader('PRIORITY'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          PrioritySelector(
            selectedPriority: createWoState.draft.priority,
            onPrioritySelected: controller.setPriority,
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Description Section
          _buildSectionHeader('DESCRIPTION'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          ViaInput(
            controller: TextEditingController(text: createWoState.draft.description),
            onChanged: controller.setDescription,
            label: 'Description',
            placeholder: 'Describe the work to be performed...',
            maxLines: 4,
            errorText: createWoState.draft.description.length < 10
                ? 'Description must be at least 10 characters'
                : null,
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
}
