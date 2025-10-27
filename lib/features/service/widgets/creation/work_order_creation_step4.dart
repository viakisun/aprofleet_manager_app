import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/work_order.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../../core/widgets/common/cards/base_card.dart';
import '../../../../core/widgets/common/buttons/primary_button.dart';
import '../../../../core/widgets/common/buttons/secondary_button.dart';
import '../../controllers/work_order_creation_controller.dart';
import '../parts_list.dart';

/// Fourth step of work order creation: Parts and Review
class WorkOrderCreationStep4 extends ConsumerWidget {
  final WorkOrderCreationController controller;
  final VoidCallback onCreateWorkOrder;

  const WorkOrderCreationStep4({
    super.key,
    required this.controller,
    required this.onCreateWorkOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createWoState = ref.watch(workOrderCreationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parts Section
          _buildSectionHeader('REQUIRED PARTS'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          Expanded(
            child: PartsList(
              parts: createWoState.draft.parts ?? [],
              onPartsChanged: controller.setParts,
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Review Section
          _buildSectionHeader('REVIEW'),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewItem('Type', createWoState.draft.type.displayName),
                _buildReviewItem(
                    'Priority', createWoState.draft.priority.displayName),
                _buildReviewItem(
                    'Cart',
                    createWoState.draft.cartId.isEmpty
                        ? 'Not selected'
                        : createWoState.draft.cartId),
                _buildReviewItem(
                    'Description',
                    createWoState.draft.description.isEmpty
                        ? 'Not provided'
                        : createWoState.draft.description),
                if (createWoState.draft.scheduledAt != null)
                  _buildReviewItem('Scheduled',
                      _formatDateTime(createWoState.draft.scheduledAt!)),
                if (createWoState.draft.technician != null)
                  _buildReviewItem(
                      'Technician', createWoState.draft.technician!),
                if (createWoState.draft.parts?.isNotEmpty == true)
                  _buildReviewItem(
                      'Parts', '${createWoState.draft.parts!.length} items'),
              ],
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Save Draft',
                  onPressed: controller.canSaveDraft()
                      ? () {
                          // Save draft logic
                        }
                      : null,
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingItem),
              Expanded(
                child: PrimaryButton(
                  text: 'Create Work Order',
                  onPressed: controller.canProceedToNextStep(3)
                      ? onCreateWorkOrder
                      : null,
                  isLoading: createWoState.isLoading,
                ),
              ),
            ],
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

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: IndustrialDarkTokens.spacingCompact),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                color: IndustrialDarkTokens.textSecondary,
                fontWeight: IndustrialDarkTokens.fontWeightMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                color: IndustrialDarkTokens.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
