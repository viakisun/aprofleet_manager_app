import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/services/mock/mock_api.dart';

class CartInventoryController extends StateNotifier<CartInventoryState> {
  CartInventoryController(this.ref) : super(CartInventoryState.initial()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    // Load initial carts
    ref.read(cartsProvider.future).then((carts) {
      state = state.copyWith(carts: AsyncValue.data(carts), isLoading: false);
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

  void setModelFilter(String model) {
    state = state.copyWith(modelFilter: model);
  }

  void setBatteryRangeFilter(double minBattery, double maxBattery) {
    state = state.copyWith(
      minBatteryFilter: minBattery,
      maxBatteryFilter: maxBattery,
    );
  }

  /// 카트들을 경로 상에 배치
  Future<void> updateCartPositionsAlongRoute() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Mock API를 통해 카트 위치 업데이트
      await MockApi().updateCartPositionsAlongRoute();
      
      // 카트 데이터 새로고침
      final updatedCarts = await ref.read(cartsProvider.future);
      state = state.copyWith(
        carts: AsyncValue.data(updatedCarts),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  List<Cart> getFilteredCarts(List<Cart> carts) {
    var filteredCarts = carts;

    // Apply status filters
    if (state.statusFilters.isNotEmpty) {
      filteredCarts = filteredCarts
          .where((cart) => state.statusFilters.contains(cart.status))
          .toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filteredCarts = filteredCarts.where((cart) {
        return cart.id.toLowerCase().contains(query) ||
            cart.model.toLowerCase().contains(query) ||
            (cart.location?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply model filter
    if (state.modelFilter.isNotEmpty) {
      filteredCarts = filteredCarts
          .where((cart) => cart.model == state.modelFilter)
          .toList();
    }

    // Apply battery range filter
    if (state.minBatteryFilter != null || state.maxBatteryFilter != null) {
      filteredCarts = filteredCarts.where((cart) {
        final battery = cart.batteryPct;
        final minBattery = state.minBatteryFilter ?? 0.0;
        final maxBattery = state.maxBatteryFilter ?? 100.0;
        return (battery ?? 0) >= minBattery && (battery ?? 0) <= maxBattery;
      }).toList();
    }

    return filteredCarts;
  }

  Map<String, int> getStats() {
    final carts = state.carts.valueOrNull ?? [];
    final stats = <String, int>{
      'total': carts.length,
      'active': carts.where((c) => c.status == CartStatus.active).length,
      'idle': carts.where((c) => c.status == CartStatus.idle).length,
      'charging': carts.where((c) => c.status == CartStatus.charging).length,
      'maintenance':
          carts.where((c) => c.status == CartStatus.maintenance).length,
      'offline': carts.where((c) => c.status == CartStatus.offline).length,
    };
    return stats;
  }

  Map<CartStatus, int> getStatusCounts() {
    final carts = state.carts.valueOrNull ?? [];
    final counts = <CartStatus, int>{};
    for (final cart in carts) {
      counts[cart.status] = (counts[cart.status] ?? 0) + 1;
    }
    return counts;
  }
}

class CartInventoryState {
  final AsyncValue<List<Cart>> carts;
  final Set<CartStatus> statusFilters;
  final String searchQuery;
  final String modelFilter;
  final double? minBatteryFilter;
  final double? maxBatteryFilter;
  final bool isLoading;

  const CartInventoryState({
    required this.carts,
    required this.statusFilters,
    required this.searchQuery,
    required this.modelFilter,
    this.minBatteryFilter,
    this.maxBatteryFilter,
    required this.isLoading,
  });

  factory CartInventoryState.initial() {
    return const CartInventoryState(
      carts: AsyncValue.loading(),
      statusFilters: {},
      searchQuery: '',
      modelFilter: '',
      isLoading: true,
    );
  }

  CartInventoryState copyWith({
    AsyncValue<List<Cart>>? carts,
    Set<CartStatus>? statusFilters,
    String? searchQuery,
    String? modelFilter,
    double? minBatteryFilter,
    double? maxBatteryFilter,
    bool? isLoading,
  }) {
    return CartInventoryState(
      carts: carts ?? this.carts,
      statusFilters: statusFilters ?? this.statusFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      modelFilter: modelFilter ?? this.modelFilter,
      minBatteryFilter: minBatteryFilter ?? this.minBatteryFilter,
      maxBatteryFilter: maxBatteryFilter ?? this.maxBatteryFilter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final cartInventoryControllerProvider =
    StateNotifierProvider<CartInventoryController, CartInventoryState>((ref) {
  return CartInventoryController(ref);
});
