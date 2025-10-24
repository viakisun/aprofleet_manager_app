import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../domain/models/cart.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/services/providers.dart';
import '../../../../core/widgets/via/via_card.dart';
import '../../../../core/widgets/via/via_input.dart';
import '../../../../core/widgets/via/via_button.dart';
import '../../../../core/widgets/via/via_status_badge.dart';
import '../../controllers/work_order_creation_controller.dart';

/// Second step of work order creation: Cart and Location selection
class WorkOrderCreationStep2 extends ConsumerStatefulWidget {
  final WorkOrderCreationController controller;

  const WorkOrderCreationStep2({
    super.key,
    required this.controller,
  });

  @override
  ConsumerState<WorkOrderCreationStep2> createState() =>
      _WorkOrderCreationStep2State();
}

class _WorkOrderCreationStep2State
    extends ConsumerState<WorkOrderCreationStep2> {
  final TextEditingController _locationController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createWoState = ref.watch(workOrderCreationControllerProvider);
    final cartsAsync = ref.watch(cartsProvider);

    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Selection Section
          _buildSectionHeader('SELECT CART'),
          const SizedBox(height: DesignTokens.spacingMd),

          // QR Scanner Button
          ViaCard(
            onTap: _toggleScanner,
            child: Row(
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: DesignTokens.textPrimary,
                  size: DesignTokens.iconMd,
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Scan QR Code',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      Text(
                        'Scan cart QR code to auto-select',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondary,
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

          // Cart List
          Expanded(
            child: cartsAsync.when(
              data: (cartList) => ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  final cart = cartList[index];
                  final isSelected = createWoState.draft.cartId == cart.id;

                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: DesignTokens.spacingSm),
                    child: ViaCard(
                      onTap: () => widget.controller.setCartId(cart.id),
                    child: Row(
                      children: [
                        // Selection indicator
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? DesignTokens.textPrimary
                                  : DesignTokens.borderPrimary,
                              width: 2,
                            ),
                            color: isSelected
                                ? DesignTokens.textPrimary
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: DesignTokens.bgPrimary,
                                )
                              : null,
                        ),
                        const SizedBox(width: DesignTokens.spacingMd),

                        // Cart info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart.id,
                                style: const TextStyle(
                                  fontSize: DesignTokens.fontSizeMd,
                                  fontWeight: DesignTokens.fontWeightSemibold,
                                  color: DesignTokens.textPrimary,
                                ),
                              ),
                              Text(
                                '${cart.manufacturer} ${cart.model}',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeSm,
                                  color: DesignTokens.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status indicator
                        ViaStatusBadge(
                          label: cart.status.displayName.toUpperCase(),
                          status: _mapCartStatusToViaStatus(cart.status),
                        ),
                      ],
                    ),
                  ),
                  );
                },
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading carts: $error',
                  style: TextStyle(color: DesignTokens.textSecondary),
                ),
              ),
            ),
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Location Section
          _buildSectionHeader('LOCATION'),
          const SizedBox(height: DesignTokens.spacingMd),
          ViaInput(
            controller: _locationController,
            onChanged: widget.controller.setLocation,
            label: 'Location',
            placeholder: 'Enter work location (optional)',
            prefixIcon: Icons.location_on,
          ),

          // QR Scanner Modal
          if (_isScanning) _buildQRScanner(),
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

  Widget _buildQRScanner() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Scan Cart QR Code',
              style: TextStyle(
                color: DesignTokens.textPrimary,
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightSemibold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      widget.controller.setCartId(barcode.rawValue!);
                      setState(() {
                        _isScanning = false;
                      });
                      break;
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: ViaButton.ghost(
                text: 'Cancel',
                onPressed: () {
                  setState(() {
                    _isScanning = false;
                  });
                },
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleScanner() {
    setState(() {
      _isScanning = !_isScanning;
    });
  }

  ViaStatusType _mapCartStatusToViaStatus(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return ViaStatusType.active;
      case CartStatus.idle:
        return ViaStatusType.idle;
      case CartStatus.charging:
        return ViaStatusType.charging;
      case CartStatus.maintenance:
        return ViaStatusType.maintenance;
      case CartStatus.offline:
        return ViaStatusType.offline;
    }
  }
}
