import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/cart.dart';
import '../controllers/live_map_controller.dart';

/// Filtered carts provider with automatic caching
/// This prevents unnecessary rebuilds by only updating when filter params or cart data changes
final filteredCartsProvider = Provider<List<Cart>>((ref) {
  final state = ref.watch(liveMapControllerProvider);

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

  return carts;
});
