import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';

class CartRegistrationController extends StateNotifier<CartRegistrationState> {
  CartRegistrationController(this.ref) : super(CartRegistrationState.initial());

  final Ref ref;

  void generateCartId() {
    // This would typically get the next available ID from the repository
    // For now, we'll generate a simple sequential ID
    final now = DateTime.now();
    final cartId =
        formatCartId(1, now.year); // This would be the next sequential number
    state = state.copyWith(cartId: cartId);
  }

  void setVin(String vin) {
    state = state.copyWith(vin: vin);
  }

  void setManufacturer(String manufacturer) {
    state = state.copyWith(manufacturer: manufacturer);
  }

  void setModel(String model) {
    state = state.copyWith(model: model);
  }

  void setYear(int year) {
    state = state.copyWith(year: year);
  }

  void setColor(String color) {
    state = state.copyWith(color: color);
  }

  void setBatteryType(String batteryType) {
    state = state.copyWith(batteryType: batteryType);
  }

  void setVoltage(int voltage) {
    state = state.copyWith(voltage: voltage);
  }

  void setSeating(int seating) {
    state = state.copyWith(seating: seating);
  }

  void setMaxSpeed(double maxSpeed) {
    state = state.copyWith(maxSpeed: maxSpeed);
  }

  void setGpsTrackerId(String gpsTrackerId) {
    state = state.copyWith(gpsTrackerId: gpsTrackerId);
  }

  void setTelemetryDeviceId(String telemetryDeviceId) {
    state = state.copyWith(telemetryDeviceId: telemetryDeviceId);
  }

  void setComponentSerial(String component, String serial) {
    final updatedSerials = Map<String, String>.from(state.componentSerials);
    updatedSerials[component] = serial;
    state = state.copyWith(componentSerials: updatedSerials);
  }

  void removeComponentSerial(String component) {
    final updatedSerials = Map<String, String>.from(state.componentSerials);
    updatedSerials.remove(component);
    state = state.copyWith(componentSerials: updatedSerials);
  }

  void setImagePath(String photoKey, String path) {
    final updatedPaths = Map<String, String>.from(state.imagePaths);
    updatedPaths[photoKey] = path;
    state = state.copyWith(imagePaths: updatedPaths);
  }

  void removeImage(String photoKey) {
    final updatedPaths = Map<String, String>.from(state.imagePaths);
    updatedPaths.remove(photoKey);
    state = state.copyWith(imagePaths: updatedPaths);
  }

  void setPurchaseDate(DateTime purchaseDate) {
    state = state.copyWith(purchaseDate: purchaseDate);
  }

  void setWarrantyExpiry(DateTime warrantyExpiry) {
    state = state.copyWith(warrantyExpiry: warrantyExpiry);
  }

  void setInsuranceNumber(String insuranceNumber) {
    state = state.copyWith(insuranceNumber: insuranceNumber);
  }

  void setOdometer(double odometer) {
    state = state.copyWith(odometer: odometer);
  }

  void reset() {
    state = CartRegistrationState.initial();
    generateCartId();
  }

  bool canProceedToNextStep(int currentStep) {
    switch (currentStep) {
      case 0: // Basic Info
        return state.vin.isNotEmpty &&
            state.manufacturer != null &&
            state.model != null;
      case 1: // Technical Specs
        return state.batteryType != null &&
            state.voltage != null &&
            state.seating != null;
      case 2: // Components
        return true;
      case 3: // Review
        return true;
      default:
        return false;
    }
  }

  List<String> getValidationErrors() {
    final errors = <String>[];

    if (state.vin.isEmpty) {
      errors.add('VIN is required');
    } else if (state.vin.length < 11 || state.vin.length > 17) {
      errors.add('VIN must be 11-17 characters');
    }

    if (state.manufacturer == null) {
      errors.add('Manufacturer is required');
    }

    if (state.model == null) {
      errors.add('Model is required');
    }

    if (state.batteryType == null) {
      errors.add('Battery type is required');
    }

    if (state.voltage == null) {
      errors.add('Voltage is required');
    }

    if (state.seating == null) {
      errors.add('Seating capacity is required');
    }

    return errors;
  }

  bool isVinUnique(String vin) {
    // This would typically check against existing carts in the repository
    // For now, we'll assume all VINs are unique
    return true;
  }
}

class CartRegistrationState {
  final String cartId;
  final String vin;
  final String? manufacturer;
  final String? model;
  final int? year;
  final String? color;
  final String? batteryType;
  final int? voltage;
  final int? seating;
  final double? maxSpeed;
  final String? gpsTrackerId;
  final String? telemetryDeviceId;
  final Map<String, String> componentSerials;
  final Map<String, String> imagePaths;
  final DateTime? purchaseDate;
  final DateTime? warrantyExpiry;
  final String? insuranceNumber;
  final double? odometer;
  final bool isLoading;
  final String? error;

  const CartRegistrationState({
    required this.cartId,
    required this.vin,
    this.manufacturer,
    this.model,
    this.year,
    this.color,
    this.batteryType,
    this.voltage,
    this.seating,
    this.maxSpeed,
    this.gpsTrackerId,
    this.telemetryDeviceId,
    required this.componentSerials,
    required this.imagePaths,
    this.purchaseDate,
    this.warrantyExpiry,
    this.insuranceNumber,
    this.odometer,
    required this.isLoading,
    this.error,
  });

  factory CartRegistrationState.initial() {
    return const CartRegistrationState(
      cartId: '',
      vin: '',
      componentSerials: {},
      imagePaths: {},
      isLoading: false,
    );
  }

  CartRegistrationState copyWith({
    String? cartId,
    String? vin,
    String? manufacturer,
    String? model,
    int? year,
    String? color,
    String? batteryType,
    int? voltage,
    int? seating,
    double? maxSpeed,
    String? gpsTrackerId,
    String? telemetryDeviceId,
    Map<String, String>? componentSerials,
    Map<String, String>? imagePaths,
    DateTime? purchaseDate,
    DateTime? warrantyExpiry,
    String? insuranceNumber,
    double? odometer,
    bool? isLoading,
    String? error,
  }) {
    return CartRegistrationState(
      cartId: cartId ?? this.cartId,
      vin: vin ?? this.vin,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      batteryType: batteryType ?? this.batteryType,
      voltage: voltage ?? this.voltage,
      seating: seating ?? this.seating,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      gpsTrackerId: gpsTrackerId ?? this.gpsTrackerId,
      telemetryDeviceId: telemetryDeviceId ?? this.telemetryDeviceId,
      componentSerials: componentSerials ?? this.componentSerials,
      imagePaths: imagePaths ?? this.imagePaths,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyExpiry: warrantyExpiry ?? this.warrantyExpiry,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      odometer: odometer ?? this.odometer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final cartRegistrationControllerProvider =
    StateNotifierProvider<CartRegistrationController, CartRegistrationState>(
        (ref) {
  return CartRegistrationController(ref);
});
