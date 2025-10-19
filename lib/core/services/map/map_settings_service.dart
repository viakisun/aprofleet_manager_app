import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_provider_type.dart';

/// Service for managing map provider settings
class MapSettingsService {
  static const String _providerKey = 'map_provider';
  static const MapProviderType _defaultProvider = MapProviderType.googleMaps;

  /// Get the currently selected map provider
  Future<MapProviderType> getSelectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final providerId = prefs.getString(_providerKey);

    if (providerId == null) {
      return _defaultProvider;
    }

    return MapProviderType.values.firstWhere(
      (provider) => provider.identifier == providerId,
      orElse: () => _defaultProvider,
    );
  }

  /// Set the selected map provider
  Future<void> setSelectedProvider(MapProviderType provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_providerKey, provider.identifier);
  }

  /// Get default provider
  MapProviderType get defaultProvider => _defaultProvider;
}

/// Riverpod provider for map settings service
final mapSettingsServiceProvider = Provider<MapSettingsService>((ref) {
  return MapSettingsService();
});

/// Riverpod provider for current map provider
final currentMapProviderProvider = FutureProvider<MapProviderType>((ref) async {
  final service = ref.read(mapSettingsServiceProvider);
  return await service.getSelectedProvider();
});
