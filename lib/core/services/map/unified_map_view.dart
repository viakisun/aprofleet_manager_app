import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/cart.dart';
import 'map_adapter.dart';
import 'map_provider_type.dart';
import 'map_settings_service.dart';
import 'google_map_view.dart';

/// Unified map view that switches between different map providers
class UnifiedMapView extends ConsumerStatefulWidget {
  final List<Cart> carts;
  final Function(Cart) onCartTap;
  final Function(LatLng)? onMapTap;
  final Function(CameraPosition)? onCameraChanged;
  final CameraPosition? initialCameraPosition;
  final bool showUserLocation;
  final double mapOpacity;
  final bool isSatellite;

  const UnifiedMapView({
    super.key,
    required this.carts,
    required this.onCartTap,
    this.onMapTap,
    this.onCameraChanged,
    this.initialCameraPosition,
    this.showUserLocation = false,
    this.mapOpacity = 0.5,
    this.isSatellite = true,
  });

  @override
  ConsumerState<UnifiedMapView> createState() => UnifiedMapViewState();
}

class UnifiedMapViewState extends ConsumerState<UnifiedMapView> {
  MapProviderType? _currentProvider;
  bool _isLoading = true;
  String? _error;
  late bool _isSatellite;

  @override
  void initState() {
    super.initState();
    _isSatellite = widget.isSatellite;
    _loadMapProvider();
  }

  Future<void> _loadMapProvider() async {
    try {
      final provider =
          await ref.read(mapSettingsServiceProvider).getSelectedProvider();
      setState(() {
        _currentProvider = provider;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Map Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _loadMapProvider();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildMapWidget();
  }

  Widget _buildMapWidget() {
    switch (_currentProvider) {
      case MapProviderType.googleMaps:
        return GoogleMapView(
          carts: widget.carts,
          onCartTap: widget.onCartTap,
          onMapTap: widget.onMapTap,
          onCameraChanged: widget.onCameraChanged,
          initialCameraPosition: widget.initialCameraPosition,
          showUserLocation: widget.showUserLocation,
          mapOpacity: widget.mapOpacity,
          isSatellite: _isSatellite,
        );

      default:
        return const Center(
          child: Text('Unsupported map provider'),
        );
    }
  }

  /// Switch to a different map provider
  Future<void> switchProvider(MapProviderType provider) async {
    try {
      await ref.read(mapSettingsServiceProvider).setSelectedProvider(provider);
      setState(() {
        _currentProvider = provider;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to switch map provider: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Get current map provider
  MapProviderType? get currentProvider => _currentProvider;

  void toggleLayer() {
    setState(() {
      _isSatellite = !_isSatellite;
    });
  }
}
