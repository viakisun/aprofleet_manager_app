import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide Stepper;
import '../../../core/widgets/qr/qr_label.dart';
import '../../../core/constants/app_constants.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_toast.dart';
import '../../../core/widgets/via/via_bottom_sheet.dart';
import '../../../core/widgets/via/via_button.dart';
import '../controllers/cart_registration_controller.dart';
import '../widgets/registration_stepper.dart';
import '../widgets/component_checklist.dart';
import '../widgets/image_upload_grid.dart';

class CartRegistrationPage extends ConsumerStatefulWidget {
  const CartRegistrationPage({super.key});

  @override
  ConsumerState<CartRegistrationPage> createState() =>
      _CartRegistrationPageState();
}

class _CartRegistrationPageState extends ConsumerState<CartRegistrationPage> {
  late CartRegistrationController _controller;
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = ref.read(cartRegistrationControllerProvider.notifier);
    _controller.generateCartId();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final registrationState = ref.watch(cartRegistrationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.registerCart),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: Column(
        children: [
          // Stepper
          RegistrationStepper(
            currentStep: _currentStep,
            steps: RegistrationStepperBuilder.buildCartRegistrationSteps(),
            onStepTap: (step) {
              if (step <= _currentStep) {
                _pageController.animateToPage(
                  step,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
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
          _buildNavigation(registrationState),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    final registrationState = ref.watch(cartRegistrationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BASIC INFORMATION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Cart ID (Auto-generated)
          TextFormField(
            initialValue: registrationState.cartId,
            decoration: const InputDecoration(
              labelText: 'Cart ID',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.refresh, color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            readOnly: true,
            onTap: () => _controller.generateCartId(),
          ),

          const SizedBox(height: 16),

          // VIN
          TextFormField(
            initialValue: registrationState.vin,
            decoration: const InputDecoration(
              labelText: 'VIN',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              hintText: 'Enter 17-character VIN',
            ),
            style: const TextStyle(color: Colors.white),
            maxLength: 17,
            onChanged: _controller.setVin,
            validator: (value) {
              if (value == null || value.length < 11 || value.length > 17) {
                return 'VIN must be 11-17 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Manufacturer and Model
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: registrationState.manufacturer,
                  decoration: const InputDecoration(
                    labelText: 'Manufacturer',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: AppConstants.manufacturers.map((manufacturer) {
                    return DropdownMenuItem(
                      value: manufacturer,
                      child: Text(manufacturer),
                    );
                  }).toList(),
                  onChanged: (manufacturer) {
                    if (manufacturer != null) {
                      _controller.setManufacturer(manufacturer);
                      _controller.setModel(
                          ''); // Reset model when manufacturer changes
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: registrationState.model,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: (registrationState.manufacturer != null
                          ? AppConstants.modelsByManufacturer[
                                  registrationState.manufacturer] ??
                              []
                          : [])
                      .map((model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (model) {
                    if (model != null) {
                      _controller.setModel(model);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Year and Color
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: registrationState.year,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: List.generate(20, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (year) {
                    if (year != null) {
                      _controller.setYear(year);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: registrationState.color,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    hintText: 'e.g., White, Black',
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _controller.setColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // QR Code Preview
          const Text(
            'QR CODE PREVIEW',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          Center(
            child: QRLabel(
              data: registrationState.cartId,
              title: 'Cart QR Code',
              size: 150,
              showSaveButton: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final registrationState = ref.watch(cartRegistrationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TECHNICAL SPECIFICATIONS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Battery Type and Voltage
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: registrationState.batteryType,
                  decoration: const InputDecoration(
                    labelText: 'Battery Type',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: AppConstants.batteryTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (type) {
                    if (type != null) {
                      _controller.setBatteryType(type);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: registrationState.voltage,
                  decoration: const InputDecoration(
                    labelText: 'Voltage',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: AppConstants.voltageOptions.map((voltage) {
                    return DropdownMenuItem(
                      value: voltage,
                      child: Text('${voltage}V'),
                    );
                  }).toList(),
                  onChanged: (voltage) {
                    if (voltage != null) {
                      _controller.setVoltage(voltage);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Seating and Max Speed
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: registrationState.seating,
                  decoration: const InputDecoration(
                    labelText: 'Seating',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  items: AppConstants.seatingOptions.map((seats) {
                    return DropdownMenuItem(
                      value: seats,
                      child: Text('$seats seats'),
                    );
                  }).toList(),
                  onChanged: (seating) {
                    if (seating != null) {
                      _controller.setSeating(seating);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  initialValue: registrationState.maxSpeed?.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Max Speed (km/h)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    hintText: '25',
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final speed = double.tryParse(value);
                    if (speed != null) {
                      _controller.setMaxSpeed(speed);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // GPS and Telemetry IDs
          TextFormField(
            initialValue: registrationState.gpsTrackerId,
            decoration: const InputDecoration(
              labelText: 'GPS Tracker ID',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              hintText: 'GPS-001',
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: _controller.setGpsTrackerId,
          ),

          const SizedBox(height: 16),

          TextFormField(
            initialValue: registrationState.telemetryDeviceId,
            decoration: const InputDecoration(
              labelText: 'Telemetry Device ID',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              hintText: 'TEL-001',
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: _controller.setTelemetryDeviceId,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final registrationState = ref.watch(cartRegistrationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Components checklist
            ComponentChecklist(
              components: ComponentChecklistBuilder.buildDefaultComponents(),
              onComponentsChanged: (components) {
                // Handle component changes if needed
              },
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

            // Photo uploads
            ImageUploadGrid(
              images: registrationState.images ?? [],
              onImagesChanged: (images) {
                _controller.setImages(images);
              },
              maxImages: 10,
              allowedCategories: const [
                'General',
                'Damage',
                'Components',
                'Documents'
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep4() {
    final registrationState = ref.watch(cartRegistrationControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REGISTRATION SUMMARY',
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
                color: Colors.white.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow('Cart ID', registrationState.cartId),
                _buildSummaryRow('VIN', registrationState.vin),
                _buildSummaryRow('Manufacturer',
                    registrationState.manufacturer ?? 'Not specified'),
                _buildSummaryRow(
                    'Model', registrationState.model ?? 'Not specified'),
                _buildSummaryRow('Year',
                    registrationState.year?.toString() ?? 'Not specified'),
                _buildSummaryRow(
                    'Color', registrationState.color ?? 'Not specified'),
                _buildSummaryRow('Battery Type',
                    registrationState.batteryType ?? 'Not specified'),
                _buildSummaryRow(
                    'Voltage', '${registrationState.voltage ?? 0}V'),
                _buildSummaryRow(
                    'Seating', '${registrationState.seating ?? 0} seats'),
                if (registrationState.maxSpeed != null)
                  _buildSummaryRow(
                      'Max Speed', '${registrationState.maxSpeed} km/h'),
                if (registrationState.gpsTrackerId != null)
                  _buildSummaryRow(
                      'GPS Tracker ID', registrationState.gpsTrackerId!),
                if (registrationState.telemetryDeviceId != null)
                  _buildSummaryRow('Telemetry Device ID',
                      registrationState.telemetryDeviceId!),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Additional Info
          const Text(
            'ADDITIONAL INFORMATION',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Purchase Date
          TextFormField(
            initialValue: registrationState.purchaseDate != null
                ? DateFormat('MMM dd, yyyy')
                    .format(registrationState.purchaseDate!)
                : '',
            decoration: const InputDecoration(
              labelText: 'Purchase Date',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            readOnly: true,
            onTap: () => _selectPurchaseDate(),
          ),

          const SizedBox(height: 16),

          // Warranty Expiry
          TextFormField(
            initialValue: registrationState.warrantyExpiry != null
                ? DateFormat('MMM dd, yyyy')
                    .format(registrationState.warrantyExpiry!)
                : '',
            decoration: const InputDecoration(
              labelText: 'Warranty Expiry',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
            readOnly: true,
            onTap: () => _selectWarrantyExpiry(),
          ),

          const SizedBox(height: 16),

          // Insurance Number
          TextFormField(
            initialValue: registrationState.insuranceNumber,
            decoration: const InputDecoration(
              labelText: 'Insurance Number',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              hintText: 'INS-001',
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: _controller.setInsuranceNumber,
          ),

          const SizedBox(height: 16),

          // Odometer
          TextFormField(
            initialValue: registrationState.odometer?.toString(),
            decoration: const InputDecoration(
              labelText: 'Odometer (km)',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              hintText: '0',
            ),
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final odometer = double.tryParse(value);
              if (odometer != null) {
                _controller.setOdometer(odometer);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(registrationState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
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
              text: _currentStep == 3 ? 'Register Cart' : 'Next',
              onPressed: _canProceed()
                  ? (_currentStep == 3 ? _registerCart : _nextStep)
                  : null,
              type: ActionButtonType.primary,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  List<Widget> _buildComponentChecklist(registrationState) {
    final components = [
      'Battery Pack',
      'Motor Controller',
      'GPS Module',
      'Front Tire',
      'Rear Tire',
    ];

    return components.map((component) {
      final serialKey = component.toLowerCase().replaceAll(' ', '_');
      final serial = registrationState.componentSerials[serialKey];

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: serial != null && serial.isNotEmpty,
                  onChanged: (value) {
                    if (value == true) {
                      _controller.setComponentSerial(serialKey, '');
                    } else {
                      _controller.removeComponentSerial(serialKey);
                    }
                  },
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                ),
                Expanded(
                  child: Text(
                    component,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (serial != null && serial.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextFormField(
                initialValue: serial,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  hintText: 'Enter serial number',
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) =>
                    _controller.setComponentSerial(serialKey, value),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }

  // ignore: unused_element
  Widget _buildPhotoUploads(registrationState) {
    final photoTypes = ['Front', 'Side', 'Serial Plate'];

    return Column(
      children: photoTypes.map((type) {
        final photoKey = type.toLowerCase().replaceAll(' ', '_');
        final photoPath = registrationState.imagePaths[photoKey];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$type Photo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (photoPath != null) ...[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(
                      File(photoPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _controller.removeImage(photoKey),
                ),
              ] else ...[
                ActionButton(
                  text: 'Capture',
                  onPressed: () => _capturePhoto(photoKey),
                  type: ActionButtonType.secondary,
                  icon: Icons.camera_alt,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
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

  bool _canProceed() {
    final registrationState = ref.read(cartRegistrationControllerProvider);

    switch (_currentStep) {
      case 0: // Basic Info
        return registrationState.vin.isNotEmpty &&
            registrationState.manufacturer != null &&
            registrationState.model != null;
      case 1: // Technical Specs
        return registrationState.batteryType != null &&
            registrationState.voltage != null &&
            registrationState.seating != null;
      case 2: // Components
        return true;
      case 3: // Review
        return true;
      default:
        return false;
    }
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

  Future<void> _capturePhoto(String photoKey) async {
    try {
      // Request camera permission
      final permission = await Permission.camera.request();
      if (permission != PermissionStatus.granted) {
        if (mounted) {
          ViaToast.show(
            context: context,
            message: 'Camera permission is required to capture photos',
            variant: ViaToastVariant.error,
          );
        }
        return;
      }

      // Show options
      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.camera_alt, color: Colors.white),
                        title: const Text('Take Photo',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.camera, photoKey);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library,
                            color: Colors.white),
                        title: const Text('Choose from Gallery',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.gallery, photoKey);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Failed to capture photo: $e',
          variant: ViaToastVariant.error,
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source, String photoKey) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // Save to app directory
        final directory = await getApplicationDocumentsDirectory();
        final cartDir = Directory(
            '${directory.path}/carts/${ref.read(cartRegistrationControllerProvider).cartId}');
        if (!await cartDir.exists()) {
          await cartDir.create(recursive: true);
        }

        final fileName = '$photoKey.jpg';
        final filePath = '${cartDir.path}/$fileName';
        await image.saveTo(filePath);
        _controller.setImagePath(photoKey, filePath);

        if (mounted) {
          ViaToast.show(
            context: context,
            message: 'Photo saved successfully',
            variant: ViaToastVariant.success,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Failed to save photo: $e',
          variant: ViaToastVariant.error,
        );
      }
    }
  }

  Future<void> _selectPurchaseDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
      _controller.setPurchaseDate(selectedDate);
    }
  }

  Future<void> _selectWarrantyExpiry() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
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
      _controller.setWarrantyExpiry(selectedDate);
    }
  }

  Future<void> _registerCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final registrationState = ref.read(cartRegistrationControllerProvider);
      final cartRegistration = CartRegistration(
        vin: registrationState.vin,
        manufacturer: registrationState.manufacturer!,
        model: registrationState.model!,
        year: registrationState.year!,
        color: registrationState.color,
        batteryType: registrationState.batteryType!,
        voltage: registrationState.voltage!,
        seating: registrationState.seating!,
        maxSpeed: registrationState.maxSpeed,
        gpsTrackerId: registrationState.gpsTrackerId,
        telemetryDeviceId: registrationState.telemetryDeviceId,
        componentSerials: registrationState.componentSerials,
        imagePaths: registrationState.imagePaths,
        purchaseDate: registrationState.purchaseDate,
        warrantyExpiry: registrationState.warrantyExpiry,
        insuranceNumber: registrationState.insuranceNumber,
        odometer: registrationState.odometer,
      );

      final cart =
          await ref.read(cartRepositoryProvider).register(cartRegistration);

      if (mounted) {
        _showSuccessModal(cart);
      }
    } catch (e) {
      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Failed to register cart: $e',
          variant: ViaToastVariant.error,
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

  void _showSuccessModal(Cart cart) {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.5, 0.7],
      header: const Text(
        'Cart Registered',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: IndustrialDarkTokens.statusActive,
            size: 48,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCard),
          Text(
            cart.id,
            style: const TextStyle(
              color: IndustrialDarkTokens.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          Text(
            'Cart has been registered successfully',
            style: TextStyle(
              color: IndustrialDarkTokens.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ViaButton.primary(
            text: 'View Inventory',
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/cm/list');
            },
            isFullWidth: true,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          ViaButton.ghost(
            text: 'Register Another',
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form for new registration
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
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: const Text(
        'Exit Cart Registration?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Text(
        'Any unsaved changes will be lost.',
        style: TextStyle(color: IndustrialDarkTokens.textSecondary),
      ),
      footer: Row(
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
              text: 'Exit',
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/cm/list');
              },
            ),
          ),
        ],
      ),
    );
  }
}
