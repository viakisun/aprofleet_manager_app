import 'package:flutter/material.dart';

/// Enum for supported map providers
enum MapProviderType {
  googleMaps,
}

/// Extension to get provider metadata
extension MapProviderTypeExtension on MapProviderType {
  String get name {
    switch (this) {
      case MapProviderType.googleMaps:
        return 'Google Maps';
    }
  }

  String get description {
    switch (this) {
      case MapProviderType.googleMaps:
        return 'Excellent Korea support, familiar UI';
    }
  }

  IconData get icon {
    switch (this) {
      case MapProviderType.googleMaps:
        return Icons.map_outlined;
    }
  }

  String get identifier {
    switch (this) {
      case MapProviderType.googleMaps:
        return 'google_maps';
    }
  }
}
