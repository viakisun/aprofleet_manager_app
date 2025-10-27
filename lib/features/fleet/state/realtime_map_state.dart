import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RealtimeMapState extends ChangeNotifier {
  String? _selectedCartId;
  double _lastZoom = 18.0;
  LatLng? _lastCenter;

  String? get selectedCartId => _selectedCartId;
  double get lastZoom => _lastZoom;
  LatLng? get lastCenter => _lastCenter;

  void selectCart(String id) {
    if (_selectedCartId != id) {
      _selectedCartId = id;
      notifyListeners();
    }
  }

  void clearSelection() {
    if (_selectedCartId != null) {
      _selectedCartId = null;
      notifyListeners();
    }
  }

  void updateCamera(double zoom, LatLng center) {
    _lastZoom = zoom;
    _lastCenter = center;
    // Don't notify listeners for camera updates to avoid unnecessary rebuilds
  }

  bool isSelected(String cartId) {
    return _selectedCartId == cartId;
  }
}

final realtimeMapStateProvider = ChangeNotifierProvider<RealtimeMapState>((ref) {
  return RealtimeMapState();
});
