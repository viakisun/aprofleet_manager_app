import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/services/map/map_adapter.dart';
import '../../../core/constants/map_constants.dart';

class LiveMapController extends StateNotifier<LiveMapState> {
  LiveMapController(this.ref) : super(LiveMapState.initial()) {
    _initialize();
  }

  final Ref ref;
  List<Cart>? _cachedFilteredCarts;
  String? _lastFilterKey;
  int _cartsVersion = 0;  // Track cart updates for efficient cache invalidation

  // Debouncing for updateCarts to prevent rapid-fire updates
  DateTime _lastUpdateCartsTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _updateCartsDebounce = Duration(milliseconds: 300);

  void _initialize() {
    // Load initial carts
    ref.read(cartsProvider.future).then((carts) {
      state = state.copyWith(carts: carts, isLoading: false);
    });

    // Load saved map opacity preference
    _loadMapOpacityPreference();

    // Subscribe to position updates for all carts
    ref.listen(alertStreamProvider, (previous, next) {
      // Listen to alert stream to trigger cart updates
      // This is a simplified approach - in production you'd have a dedicated position stream
    });
  }

  Future<void> _loadMapOpacityPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOpacity = prefs.getDouble('map_opacity');
      if (savedOpacity != null) {
        state = state.copyWith(mapOpacity: savedOpacity);
      }
    } catch (e) {
      // Ignore errors, use default opacity
    }
  }

  void toggleStatusFilter(CartStatus status) {
    final filters = Set<CartStatus>.from(state.statusFilters);
    if (filters.contains(status)) {
      filters.remove(status);
    } else {
      filters.add(status);
    }
    state = state.copyWith(statusFilters: filters);
  }

  void clearFilters() {
    state = state.copyWith(statusFilters: <CartStatus>{});
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void searchCarts(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void setCameraPosition(CameraPosition position) {
    state = state.copyWith(cameraPosition: position);
  }

  void animateToCart(String cartId) {
    final cart = state.carts.firstWhere(
      (cart) => cart.id == cartId,
      orElse: () => throw StateError('Cart not found'),
    );

    final position = CameraPosition(
      center: cart.position,
      zoom: MapConstants.defaultZoom,
    );

    setCameraPosition(position);
  }

  void setZoom(double zoom) {
    final currentPosition = state.cameraPosition;
    final newPosition = currentPosition.copyWith(zoom: zoom);
    setCameraPosition(newPosition);
  }

  void setMapOpacity(double opacity) {
    final clampedOpacity = opacity.clamp(0.0, 1.0);
    state = state.copyWith(mapOpacity: clampedOpacity);
    _saveMapOpacityPreference(clampedOpacity);
  }

  Future<void> _saveMapOpacityPreference(double opacity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('map_opacity', opacity);
    } catch (e) {
      // Ignore errors, preference saving is not critical
    }
  }

  void selectCart(Cart cart) {
    state = state.copyWith(selectedCart: cart);
  }

  void clearSelection() {
    state = state.copyWith(selectedCart: null);
  }

  void navigateToCartDetail(String cartId) {
    // Navigate to cart detail page
    // This will be handled by the page using GoRouter
  }

  void navigateToCartTracking(String cartId) {
    // Enable tracking mode
    state = state.copyWith(trackingCartId: cartId);
  }

  void centerOnCart(Cart cart) {
    if (cart.position != null) {
      // Get current zoom level and add 2 for closer view
      final currentZoom = state.cameraPosition.zoom;
      final targetZoom = (currentZoom + 2).clamp(14.0, 18.0); // Clamp between reasonable bounds
      
      final newCameraPosition = CameraPosition(
        center: cart.position!,
        zoom: targetZoom,
      );
      state = state.copyWith(cameraPosition: newCameraPosition);
    }
  }

  Future<void> focusOn(LatLng target, {
    double paddingTopPx = 96,
    double paddingLeftPx = 140, // cart list width + spacing
  }) async {
    print('focusOn called with target: $target');
    print('Current camera position: ${state.cameraPosition.center}, zoom: ${state.cameraPosition.zoom}');
    
    // For now, use the existing centerOnCart logic but with offset
    // TODO: Implement proper screen coordinate offset calculation
    // This would require access to GoogleMapController which is not available here
    final currentZoom = state.cameraPosition.zoom;
    final targetZoom = (currentZoom + 2).clamp(14.0, 18.0);
    
    final newCameraPosition = CameraPosition(
      center: target,
      zoom: targetZoom,
    );
    
    print('New camera position: ${newCameraPosition.center}, zoom: ${newCameraPosition.zoom}');
    state = state.copyWith(cameraPosition: newCameraPosition);
  }

  void updateCarts(List<Cart> carts) {
    // Debounce: Prevent rapid-fire updates that cause UI lag
    final now = DateTime.now();
    final timeSinceLastUpdate = now.difference(_lastUpdateCartsTime);

    if (timeSinceLastUpdate < _updateCartsDebounce) {
      // Too soon - skip this update to prevent UI thrashing
      return;
    }

    _lastUpdateCartsTime = now;
    state = state.copyWith(carts: carts);
    _cartsVersion++;  // Increment version to invalidate cache
    _cachedFilteredCarts = null;  // Clear cache to force rebuild with new positions
  }

  List<Cart> get filteredCarts {
    // CRITICAL: Cache filtered carts to prevent new list creation on every access
    // This prevents GoogleMapView.didUpdateWidget from triggering on every cart update
    // Use version counter instead of expensive hash calculation for cache invalidation
    final filterKey = '$_cartsVersion${state.statusFilters.join(',')}_${state.searchQuery}';

    if (_lastFilterKey == filterKey && _cachedFilteredCarts != null) {
      return _cachedFilteredCarts!;  // Return cached list with same reference
    }

    var carts = state.carts;

    // Apply status filters
    if (state.statusFilters.isNotEmpty) {
      carts = carts
          .where((cart) => state.statusFilters.contains(cart.status))
          .toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      carts = carts.where((cart) {
        return cart.id.toLowerCase().contains(query) ||
            cart.model.toLowerCase().contains(query) ||
            (cart.location?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Cache the result
    _cachedFilteredCarts = carts;
    _lastFilterKey = filterKey;

    return carts;
  }

  Map<CartStatus, int> get statusCounts {
    final counts = <CartStatus, int>{};
    for (final cart in state.carts) {
      counts[cart.status] = (counts[cart.status] ?? 0) + 1;
    }
    return counts;
  }
}

class LiveMapState {
  final List<Cart> carts;
  final Set<CartStatus> statusFilters;
  final String searchQuery;
  final Cart? selectedCart;
  final String? trackingCartId;
  final CameraPosition cameraPosition;
  final bool isLoading;
  final double mapOpacity;

  const LiveMapState({
    required this.carts,
    required this.statusFilters,
    required this.searchQuery,
    this.selectedCart,
    this.trackingCartId,
    required this.cameraPosition,
    required this.isLoading,
    this.mapOpacity = 0.5,
  });

  factory LiveMapState.initial() {
    return LiveMapState(
      carts: [],
      statusFilters: {},
      searchQuery: '',
      cameraPosition: CameraPosition(
        center: MapConstants.ungpoCC,
        zoom: 17.0, // 골프장 세부사항을 더 잘 보이게 높은 줌 레벨
      ),
      isLoading: true,
    );
  }

  LiveMapState copyWith({
    List<Cart>? carts,
    Set<CartStatus>? statusFilters,
    String? searchQuery,
    Cart? selectedCart,
    String? trackingCartId,
    CameraPosition? cameraPosition,
    bool? isLoading,
    double? mapOpacity,
  }) {
    return LiveMapState(
      carts: carts ?? this.carts,
      statusFilters: statusFilters ?? this.statusFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCart: selectedCart ?? this.selectedCart,
      trackingCartId: trackingCartId ?? this.trackingCartId,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      isLoading: isLoading ?? this.isLoading,
      mapOpacity: mapOpacity ?? this.mapOpacity,
    );
  }
}

final liveMapControllerProvider =
    StateNotifierProvider<LiveMapController, LiveMapState>((ref) {
  return LiveMapController(ref);
});
