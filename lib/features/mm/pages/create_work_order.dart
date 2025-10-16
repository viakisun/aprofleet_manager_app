import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../domain/models/work_order.dart';
import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/steps/stepper.dart' as custom;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide Stepper;
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';
import '../controllers/create_wo_controller.dart';

class CreateWorkOrder extends ConsumerStatefulWidget {
  final String? preselectedCartId;

  const CreateWorkOrder({
    super.key,
    this.preselectedCartId,
  });

  @override
  ConsumerState<CreateWorkOrder> createState() => _CreateWorkOrderState();
}

class _CreateWorkOrderState extends ConsumerState<CreateWorkOrder> {
  late CreateWoController _controller;
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(createWoControllerProvider.notifier);

    // Check for draft
    _checkForDraft();

    // Set preselected cart if provided
    if (widget.preselectedCartId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.setCartId(widget.preselectedCartId!);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkForDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('draft.wo.create');

      if (draftJson != null && mounted) {
        final draft = WorkOrderDraft.fromJson(jsonDecode(draftJson));
        _controller.loadDraft(draft);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Draft found. Resume?'),
            action: SnackBarAction(
              label: 'Resume',
              onPressed: () {
                // Draft is already loaded
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Ignore draft loading errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final createWoState = ref.watch(createWoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createWorkOrder),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          TextButton(
            onPressed: _canSaveDraft() ? _saveDraft : null,
            child: const Text('Save Draft'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stepper
          custom.Stepper(
            currentStep: _currentStep,
            totalSteps: 4,
            stepTitles: const [
              'Type & Priority',
              'Cart & Location',
              'Schedule & Tech',
              'Parts & Review',
            ],
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
              ],
            ),
          ),

          // Navigation
          _buildNavigation(createWoState),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    final createWoState = ref.watch(createWoControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WORK ORDER TYPE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Type Selection
          DropdownButtonFormField<WorkOrderType>(
            value: createWoState.draft.type,
            decoration: const InputDecoration(
              labelText: 'Type',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white),
            items: WorkOrderType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.displayName),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) {
                _controller.setType(type);
                _controller.setAutoPriority(type);
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'PRIORITY',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Priority Selection
          Row(
            children: Priority.values.map((priority) {
              final isSelected = createWoState.draft.priority == priority;
              final color =
                  AppConstants.priorityColors[priority] ?? Colors.grey;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _controller.setPriority(priority),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            priority.displayName,
                            style: TextStyle(
                              color: isSelected ? color : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            priority.fullName,
                            style: TextStyle(
                              color: isSelected
                                  ? color
                                  : Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          const Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          TextFormField(
            initialValue: createWoState.draft.description,
            decoration: const InputDecoration(
              hintText: 'Describe the work to be performed...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            onChanged: _controller.setDescription,
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

  Widget _buildStep2() {
    final createWoState = ref.watch(createWoControllerProvider);
    final cartsAsync = ref.watch(cartsProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CART SELECTION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Cart Search/Selection
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: createWoState.draft.cartId.isNotEmpty
                      ? createWoState.draft.cartId
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Cart ID',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: cartsAsync.when(
                    data: (carts) => carts.map((cart) {
                      return DropdownMenuItem(
                        value: cart.id,
                        child: Text('${cart.id} - ${cart.model}'),
                      );
                    }).toList(),
                    loading: () => [],
                    error: (_, __) => [],
                  ),
                  onChanged: (cartId) {
                    if (cartId != null) {
                      _controller.setCartId(cartId);
                      _controller.setLocationFromCart(cartId);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              ActionButton(
                text: 'QR Scan',
                onPressed: () => _showQRScanner(),
                type: ActionButtonType.secondary,
                icon: Icons.qr_code_scanner,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'LOCATION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Location
          TextFormField(
            initialValue: createWoState.draft.location ?? '',
            decoration: const InputDecoration(
              hintText: 'Location where work will be performed...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: _controller.setLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final createWoState = ref.watch(createWoControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SCHEDULE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Date and Time
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: createWoState.draft.scheduledAt != null
                      ? DateFormat('MMM dd, yyyy')
                          .format(createWoState.draft.scheduledAt!)
                      : '',
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: () => _selectDate(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: createWoState.draft.scheduledAt != null
                      ? DateFormat('HH:mm')
                          .format(createWoState.draft.scheduledAt!)
                      : '',
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: () => _selectTime(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'ESTIMATED DURATION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Duration
          DropdownButtonFormField<Duration>(
            value: createWoState.draft.estimatedDuration,
            decoration: const InputDecoration(
              labelText: 'Duration',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(
                  value: Duration(minutes: 30), child: Text('30 minutes')),
              DropdownMenuItem(
                  value: Duration(hours: 1), child: Text('1 hour')),
              DropdownMenuItem(
                  value: Duration(hours: 2), child: Text('2 hours')),
              DropdownMenuItem(
                  value: Duration(hours: 4), child: Text('Half day')),
              DropdownMenuItem(
                  value: Duration(hours: 8), child: Text('Full day')),
            ],
            onChanged: (duration) {
              if (duration != null) {
                _controller.setEstimatedDuration(duration);
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'TECHNICIAN',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Technician Selection
          DropdownButtonFormField<String>(
            value: createWoState.draft.technician,
            decoration: const InputDecoration(
              labelText: 'Technician',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white),
            items: AppConstants.technicians.map((tech) {
              return DropdownMenuItem<String>(
                value: tech['name'],
                child: Text('${tech['name']} (${tech['skill']})'),
              );
            }).toList(),
            onChanged: (technician) {
              if (technician != null) {
                _controller.setTechnician(technician);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    final createWoState = ref.watch(createWoControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WORK ORDER SUMMARY',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow('Work Order ID', _generateWorkOrderId()),
                _buildSummaryRow('Type', createWoState.draft.type.displayName),
                _buildSummaryRow(
                    'Priority', createWoState.draft.priority.displayName),
                _buildSummaryRow(
                    'Description', createWoState.draft.description),
                _buildSummaryRow('Cart ID', createWoState.draft.cartId),
                if (createWoState.draft.location != null)
                  _buildSummaryRow('Location', createWoState.draft.location!),
                if (createWoState.draft.scheduledAt != null)
                  _buildSummaryRow(
                      'Scheduled',
                      DateFormat('MMM dd, yyyy HH:mm')
                          .format(createWoState.draft.scheduledAt!)),
                if (createWoState.draft.estimatedDuration != null)
                  _buildSummaryRow('Duration',
                      _formatDuration(createWoState.draft.estimatedDuration!)),
                if (createWoState.draft.technician != null)
                  _buildSummaryRow(
                      'Technician', createWoState.draft.technician!),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'PARTS SUGGESTED',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Parts List
          ..._getSuggestedParts(createWoState.draft.type).map((part) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
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
                          part['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'SKU: ${part['sku']}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Qty: ${part['defaultQty']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  Widget _buildNavigation(createWoState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: ActionButton(
                text: 'Previous',
                onPressed: () => _previousStep(),
                type: ActionButtonType.secondary,
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              text: _currentStep == 3 ? 'Create Work Order' : 'Next',
              onPressed: _canProceed()
                  ? (_currentStep == 3 ? _createWorkOrder : _nextStep)
                  : null,
              type: ActionButtonType.primary,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    final createWoState = ref.read(createWoControllerProvider);

    switch (_currentStep) {
      case 0:
        return createWoState.draft.type != null &&
            createWoState.draft.priority != null &&
            createWoState.draft.description.length >= 10;
      case 1:
        return createWoState.draft.cartId.isNotEmpty;
      case 2:
        return createWoState.draft.scheduledAt != null;
      case 3:
        return true;
      default:
        return false;
    }
  }

  bool _canSaveDraft() {
    final createWoState = ref.read(createWoControllerProvider);
    return createWoState.draft.type != null &&
        createWoState.draft.priority != null &&
        createWoState.draft.description.isNotEmpty;
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          _controller.setCartId(barcode.rawValue!);
                          Navigator.of(context).pop();
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ActionButton(
                text: 'Simulate Scan',
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSimulateDialog();
                },
                type: ActionButtonType.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimulateDialog() {
    final cartIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Simulate QR Scan',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: cartIdController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter Cart ID',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (cartIdController.text.isNotEmpty) {
                _controller.setCartId(cartIdController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      _controller.setScheduledDate(selectedDate);
    }
  }

  Future<void> _selectTime() async {
    final now = DateTime.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      _controller.setScheduledTime(selectedTime);
    }
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final createWoState = ref.read(createWoControllerProvider);
      final draftJson = jsonEncode(createWoState.draft.toJson());
      await prefs.setString('draft.wo.create', draftJson);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save draft: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createWorkOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final createWoState = ref.read(createWoControllerProvider);
      final workOrder = await _controller.createWorkOrder(createWoState.draft);

      // Clear draft
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('draft.wo.create');

      if (mounted) {
        // Show success modal
        _showSuccessModal(workOrder);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create work order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessModal(WorkOrder workOrder) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Work Order Created',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              workOrder.id,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Work order has been created successfully',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/mm/list');
            },
            child: const Text('View Work Orders'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form for new work order
              _controller.reset();
              setState(() {
                _currentStep = 0;
              });
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Create Another'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Exit Work Order Creation?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Any unsaved changes will be lost. Do you want to save as draft?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/mm/list');
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () async {
              await _saveDraft();
              Navigator.of(context).pop();
              context.go('/mm/list');
            },
            child: const Text('Save Draft'),
          ),
        ],
      ),
    );
  }

  String _generateWorkOrderId() {
    final now = DateTime.now();
    return CodeFormatters.formatWorkOrderId(
        1, now.year); // This would be the next sequential number
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  List<Map<String, dynamic>> _getSuggestedParts(WorkOrderType type) {
    // This would typically come from a service/provider
    switch (type) {
      case WorkOrderType.battery:
        return [
          {'sku': 'BAT-001', 'name': 'Battery Pack 48V', 'defaultQty': 1},
        ];
      case WorkOrderType.tire:
        return [
          {'sku': 'TIR-001', 'name': 'Front Tire 18x8.5', 'defaultQty': 1},
          {'sku': 'TIR-002', 'name': 'Rear Tire 18x8.5', 'defaultQty': 1},
        ];
      case WorkOrderType.emergencyRepair:
        return [
          {'sku': 'BRK-001', 'name': 'Brake Pad Set', 'defaultQty': 1},
          {'sku': 'MOT-001', 'name': 'Motor Controller', 'defaultQty': 1},
        ];
      default:
        return [];
    }
  }
}
