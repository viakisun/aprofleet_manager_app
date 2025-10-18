import 'package:flutter/material.dart';

import '../../../../domain/models/work_order.dart';
import '../../../../core/theme/design_tokens.dart';

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
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightSemibold,
                  color: DesignTokens.textPrimary,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addPart,
              icon: const Icon(Icons.add),
              label: const Text('Add Part'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignTokens.textPrimary,
                foregroundColor: DesignTokens.bgPrimary,
                elevation: DesignTokens.elevationNone,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: DesignTokens.spacingMd),
        
        // Parts list
        if (_parts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DesignTokens.spacingXl),
            decoration: BoxDecoration(
              color: DesignTokens.bgSecondary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              border: Border.all(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: DesignTokens.textTertiary,
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Text(
                  'No parts added yet',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    color: DesignTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  'Add parts required for this work order',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textTertiary,
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
              margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: DesignTokens.bgTertiary,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                border: Border.all(
                  color: DesignTokens.borderPrimary,
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
                            fontSize: DesignTokens.fontSizeMd,
                            fontWeight: DesignTokens.fontWeightSemibold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        if (part.notes != null) ...[
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            part.notes!,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSm,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          'Quantity: ${part.quantity}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removePart(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: DesignTokens.alertCritical,
                      size: DesignTokens.iconMd,
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
    showDialog(
      context: context,
      builder: (context) => _AddPartDialog(
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

class _AddPartDialog extends StatefulWidget {
  final Function(WoPart) onPartAdded;

  const _AddPartDialog({
    required this.onPartAdded,
  });

  @override
  State<_AddPartDialog> createState() => _AddPartDialogState();
}

class _AddPartDialogState extends State<_AddPartDialog> {
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
    return AlertDialog(
      title: const Text('Add Part'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Part Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Part name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Quantity is required';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Please enter a valid quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            TextFormField(
              controller: _serialController,
              decoration: const InputDecoration(
                labelText: 'Serial Number (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _savePart,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _savePart() {
    if (_formKey.currentState!.validate()) {
      final part = WoPart(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text),
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
}
