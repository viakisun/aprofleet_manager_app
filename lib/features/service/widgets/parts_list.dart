import 'package:flutter/material.dart';

import '../../../../domain/models/work_order.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../../core/widgets/via/via_bottom_sheet.dart';
import '../../../../core/widgets/via/via_button.dart';
import '../../../../core/widgets/via/via_input.dart';

/// Widget for managing work order parts
class PartsList extends StatefulWidget {
  final List<WoPart> parts;
  final Function(List<WoPart>) onPartsChanged;

  const PartsList({
    super.key,
    required this.parts,
    required this.onPartsChanged,
  });

  @override
  State<PartsList> createState() => _PartsListState();
}

class _PartsListState extends State<PartsList> {
  late List<WoPart> _parts;

  @override
  void initState() {
    super.initState();
    _parts = List.from(widget.parts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with add button
        Row(
          children: [
            const Expanded(
              child: Text(
                'Required Parts',
                style: TextStyle(
                  fontSize: IndustrialDarkTokens.fontSizeLabel,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                  color: IndustrialDarkTokens.textPrimary,
                ),
              ),
            ),
            ViaButton.primary(
              onPressed: _addPart,
              text: 'Add Part',
              icon: Icons.add,
              size: ViaButtonSize.small,
            ),
          ],
        ),

        const SizedBox(height: IndustrialDarkTokens.spacingItem),

        // Parts list
        if (_parts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(IndustrialDarkTokens.spacingSection),
            decoration: BoxDecoration(
              color: IndustrialDarkTokens.bgSurface,
              borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              border: Border.all(
                color: IndustrialDarkTokens.outline,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(height: IndustrialDarkTokens.spacingItem),
                Text(
                  'No parts added yet',
                  style: TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeLabel,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: IndustrialDarkTokens.spacingCompact),
                Text(
                  'Add parts required for this work order',
                  style: TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeSmall,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ..._parts.asMap().entries.map((entry) {
            final index = entry.key;
            final part = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: IndustrialDarkTokens.spacingCompact),
              padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.bgSurface,
                borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                border: Border.all(
                  color: IndustrialDarkTokens.outline,
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
                            fontSize: IndustrialDarkTokens.fontSizeLabel,
                            fontWeight: IndustrialDarkTokens.fontWeightBold,
                            color: IndustrialDarkTokens.textPrimary,
                          ),
                        ),
                        if (part.notes != null) ...[
                          const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                          Text(
                            part.notes!,
                            style: TextStyle(
                              fontSize: IndustrialDarkTokens.fontSizeSmall,
                              color: IndustrialDarkTokens.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                        Text(
                          'Quantity: ${part.quantity}',
                          style: TextStyle(
                            fontSize: IndustrialDarkTokens.fontSizeSmall,
                            color: IndustrialDarkTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removePart(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: IndustrialDarkTokens.error,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  void _addPart() {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.6, 0.8],
      header: const Text(
        'Add Part',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: _AddPartForm(
        onPartAdded: (part) {
          setState(() {
            _parts.add(part);
          });
          widget.onPartsChanged(_parts);
        },
      ),
    );
  }

  void _removePart(int index) {
    setState(() {
      _parts.removeAt(index);
    });
    widget.onPartsChanged(_parts);
  }
}

class _AddPartForm extends StatefulWidget {
  final Function(WoPart) onPartAdded;

  const _AddPartForm({
    required this.onPartAdded,
  });

  @override
  State<_AddPartForm> createState() => _AddPartFormState();
}

class _AddPartFormState extends State<_AddPartForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _serialController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ViaInput(
            controller: _nameController,
            label: 'Part Name *',
            placeholder: 'Enter part name',
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          ViaInput(
            controller: _quantityController,
            label: 'Quantity *',
            placeholder: 'Enter quantity',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          ViaInput(
            controller: _notesController,
            label: 'Notes (Optional)',
            placeholder: 'Enter notes',
            maxLines: 2,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          ViaInput(
            controller: _serialController,
            label: 'Serial Number (Optional)',
            placeholder: 'Enter serial number',
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCard),
          Row(
            children: [
              Expanded(
                child: ViaButton.ghost(
                  text: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingItem),
              Expanded(
                child: ViaButton.primary(
                  text: 'Add',
                  onPressed: _savePart,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _savePart() {
    // Simple validation
    if (_nameController.text.trim().isEmpty) {
      return;
    }
    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      return;
    }

    final part = WoPart(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      quantity: quantity,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      serialNumber: _serialController.text.trim().isEmpty
          ? null
          : _serialController.text.trim(),
    );

    widget.onPartAdded(part);
    Navigator.of(context).pop();
  }
}
