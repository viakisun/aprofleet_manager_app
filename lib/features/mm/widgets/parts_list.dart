import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class Part {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double unitPrice;
  final String category;

  const Part({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.category,
  });

  double get totalPrice => quantity * unitPrice;
}

class PartsList extends StatefulWidget {
  final List<Part> parts;
  final Function(List<Part>) onPartsChanged;

  const PartsList({
    super.key,
    required this.parts,
    required this.onPartsChanged,
  });

  @override
  State<PartsList> createState() => _PartsListState();
}

class _PartsListState extends State<PartsList> {
  late List<Part> _parts;

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
        // Header
        Row(
          children: [
            Text(
              'PARTS & MATERIALS',
              style: DesignTokens.getUppercaseLabelStyle(
                fontSize: DesignTokens.fontSizeSm,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: DesignTokens.textSecondary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _showAddPartDialog,
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: DesignTokens.statusActive.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  border: Border.all(
                    color: DesignTokens.statusActive,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: DesignTokens.iconSm,
                      color: DesignTokens.statusActive,
                    ),
                    const SizedBox(width: DesignTokens.spacingXs),
                    Text(
                      'ADD PART',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXs,
                        fontWeight: DesignTokens.fontWeightSemibold,
                        color: DesignTokens.statusActive,
                        letterSpacing: DesignTokens.letterSpacingWide,
                      ),
                    ),
                  ],
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
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: DesignTokens.iconXl,
                  color: DesignTokens.textTertiary,
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                Text(
                  'No parts added',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.textTertiary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  'Add parts and materials needed for this work order',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Column(
            children: _parts.asMap().entries.map((entry) {
              final index = entry.key;
              final part = entry.value;

              return Container(
                margin: EdgeInsets.only(
                  bottom:
                      index < _parts.length - 1 ? DesignTokens.spacingSm : 0,
                ),
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: DesignTokens.bgSecondary,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  border: Border.all(
                    color: DesignTokens.borderPrimary,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Part info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            part.name,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeMd,
                              fontWeight: DesignTokens.fontWeightSemibold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                          if (part.description.isNotEmpty) ...[
                            const SizedBox(height: DesignTokens.spacingXs),
                            Text(
                              part.description,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeSm,
                                color: DesignTokens.textSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(height: DesignTokens.spacingXs),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spacingXs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: DesignTokens.bgTertiary,
                                  borderRadius: BorderRadius.circular(
                                      DesignTokens.radiusSm),
                                ),
                                child: Text(
                                  part.category,
                                  style: TextStyle(
                                    fontSize: DesignTokens.fontSizeXs,
                                    fontWeight: DesignTokens.fontWeightMedium,
                                    color: DesignTokens.textSecondary,
                                    letterSpacing:
                                        DesignTokens.letterSpacingWide,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Quantity and price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _updateQuantity(index, part.quantity - 1),
                              icon: Icon(
                                Icons.remove,
                                size: DesignTokens.iconSm,
                                color: DesignTokens.textSecondary,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingSm,
                                vertical: DesignTokens.spacingXs,
                              ),
                              decoration: BoxDecoration(
                                color: DesignTokens.bgTertiary,
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusSm),
                                border: Border.all(
                                  color: DesignTokens.borderPrimary,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                part.quantity.toString(),
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeSm,
                                  fontWeight: DesignTokens.fontWeightSemibold,
                                  color: DesignTokens.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _updateQuantity(index, part.quantity + 1),
                              icon: Icon(
                                Icons.add,
                                size: DesignTokens.iconSm,
                                color: DesignTokens.textSecondary,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          '\$${part.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.statusActive,
                          ),
                        ),
                      ],
                    ),

                    // Remove button
                    const SizedBox(width: DesignTokens.spacingSm),
                    IconButton(
                      onPressed: () => _removePart(index),
                      icon: Icon(
                        Icons.delete_outline,
                        size: DesignTokens.iconSm,
                        color: DesignTokens.statusCritical,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

        // Total cost
        if (_parts.isNotEmpty) ...[
          const SizedBox(height: DesignTokens.spacingMd),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: DesignTokens.bgTertiary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'TOTAL COST',
                  style: DesignTokens.getUppercaseLabelStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    fontWeight: DesignTokens.fontWeightSemibold,
                    color: DesignTokens.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${_getTotalCost().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLg,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: DesignTokens.statusActive,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity < 1) return;

    setState(() {
      _parts[index] = Part(
        id: _parts[index].id,
        name: _parts[index].name,
        description: _parts[index].description,
        quantity: newQuantity,
        unitPrice: _parts[index].unitPrice,
        category: _parts[index].category,
      );
    });
    widget.onPartsChanged(_parts);
  }

  void _removePart(int index) {
    setState(() {
      _parts.removeAt(index);
    });
    widget.onPartsChanged(_parts);
  }

  void _showAddPartDialog() {
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

  double _getTotalCost() {
    return _parts.fold(0.0, (sum, part) => sum + part.totalPrice);
  }
}

class _AddPartDialog extends StatefulWidget {
  final Function(Part) onPartAdded;

  const _AddPartDialog({required this.onPartAdded});

  @override
  State<_AddPartDialog> createState() => _AddPartDialogState();
}

class _AddPartDialogState extends State<_AddPartDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitPriceController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Battery',
    'Motor',
    'Brake',
    'Tire',
    'Electronics',
    'Safety',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DesignTokens.bgSecondary,
      title: Text(
        'ADD PART',
        style: DesignTokens.getUppercaseLabelStyle(
          fontSize: DesignTokens.fontSizeLg,
          fontWeight: DesignTokens.fontWeightBold,
          color: DesignTokens.textPrimary,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: DesignTokens.textPrimary),
              decoration: InputDecoration(
                labelText: 'Part Name',
                labelStyle: TextStyle(color: DesignTokens.textSecondary),
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
                  borderSide: BorderSide(color: DesignTokens.statusActive),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter part name';
                }
                return null;
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Description
            TextFormField(
              controller: _descriptionController,
              style: TextStyle(color: DesignTokens.textPrimary),
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                labelStyle: TextStyle(color: DesignTokens.textSecondary),
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
                  borderSide: BorderSide(color: DesignTokens.statusActive),
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Category and Quantity
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    style: TextStyle(color: DesignTokens.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: DesignTokens.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                        borderSide:
                            BorderSide(color: DesignTokens.borderPrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                        borderSide:
                            BorderSide(color: DesignTokens.borderPrimary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                        borderSide:
                            BorderSide(color: DesignTokens.statusActive),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: DesignTokens.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: TextStyle(color: DesignTokens.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                        borderSide:
                            BorderSide(color: DesignTokens.borderPrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                        borderSide:
                            BorderSide(color: DesignTokens.borderPrimary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                        borderSide:
                            BorderSide(color: DesignTokens.statusActive),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Required';
                      }
                      final quantity = int.tryParse(value!);
                      if (quantity == null || quantity < 1) {
                        return 'Must be > 0';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Unit Price
            TextFormField(
              controller: _unitPriceController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: DesignTokens.textPrimary),
              decoration: InputDecoration(
                labelText: 'Unit Price (\$)',
                labelStyle: TextStyle(color: DesignTokens.textSecondary),
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
                  borderSide: BorderSide(color: DesignTokens.statusActive),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter unit price';
                }
                final price = double.tryParse(value!);
                if (price == null || price < 0) {
                  return 'Must be >= 0';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: TextStyle(
              color: DesignTokens.textSecondary,
              fontWeight: DesignTokens.fontWeightSemibold,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _addPart,
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignTokens.statusActive,
            foregroundColor: DesignTokens.bgPrimary,
          ),
          child: Text(
            'ADD PART',
            style: TextStyle(
              fontWeight: DesignTokens.fontWeightSemibold,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
        ),
      ],
    );
  }

  void _addPart() {
    if (_formKey.currentState?.validate() ?? false) {
      final part = Part(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: int.parse(_quantityController.text),
        unitPrice: double.parse(_unitPriceController.text),
        category: _selectedCategory,
      );

      widget.onPartAdded(part);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }
}
