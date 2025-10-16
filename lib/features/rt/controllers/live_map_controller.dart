import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/cart.dart';
import '../../../domain/models/telemetry.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/services/map/canvas_map_view.dart';

class LiveMapController extends StateNotifier<LiveMapState> {
  LiveMapController(this.ref) : super(LiveMapState.initial()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    // Load initial carts
    ref.read(cartsProvider.future).then((carts) {
      state = state.copyWith(carts: carts, isLoading: false);
    });

    // Subscribe to position updates for all carts
    ref.listen(alertStreamProvider, (previous, next) {
      // Listen to alert stream to trigger cart updates
      // This is a simplified approach - in production you'd have a dedicated position stream
    });
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

  void setZoom(double zoom) {
    state = state.copyWith(zoom: zoom);
  }

  void setCenterOffset(Offset offset) {
    state = state.copyWith(centerOffset: offset);
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

  List<Cart> get filteredCarts {
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
            (cart.location?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

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
  final double zoom;
  final Offset centerOffset;
  final bool isLoading;

  const LiveMapState({
    required this.carts,
    required this.statusFilters,
    required this.searchQuery,
    this.selectedCart,
    this.trackingCartId,
    required this.zoom,
    required this.centerOffset,
    required this.isLoading,
  });

  factory LiveMapState.initial() {
    return const LiveMapState(
      carts: [],
      statusFilters: {},
      searchQuery: '',
      zoom: 1.5,
      centerOffset: Offset.zero,
      isLoading: true,
    );
  }

  LiveMapState copyWith({
    List<Cart>? carts,
    Set<CartStatus>? statusFilters,
    String? searchQuery,
    Cart? selectedCart,
    String? trackingCartId,
    double? zoom,
    Offset? centerOffset,
    bool? isLoading,
  }) {
    return LiveMapState(
      carts: carts ?? this.carts,
      statusFilters: statusFilters ?? this.statusFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCart: selectedCart ?? this.selectedCart,
      trackingCartId: trackingCartId ?? this.trackingCartId,
      zoom: zoom ?? this.zoom,
      centerOffset: centerOffset ?? this.centerOffset,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final liveMapControllerProvider =
    StateNotifierProvider<LiveMapController, LiveMapState>((ref) {
  return LiveMapController(ref);
});
