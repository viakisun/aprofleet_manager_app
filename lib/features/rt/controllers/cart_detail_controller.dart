import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/cart.dart';
import '../../../domain/models/telemetry.dart';
import '../../../core/services/providers.dart';

class CartDetailController extends StateNotifier<CartDetailState> {
  final Ref ref;

  CartDetailController(this.ref) : super(CartDetailState.initial());

  void loadCart(String cartId) async {
    state = state.copyWith(isLoading: true);

    try {
      // Get cart from repository
      final carts = await ref.read(cartsProvider.future);
      final cart = carts.firstWhere((c) => c.id == cartId);

      // Get telemetry data
      final telemetry = await ref.read(telemetryProvider(cartId).future);

      state = state.copyWith(
        cart: cart,
        telemetry: telemetry,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error
    }
  }

  void refreshData() {
    if (state.cart != null) {
      loadCart(state.cart!.id);
    }
  }
}

class CartDetailState {
  final Cart? cart;
  final Telemetry? telemetry;
  final bool isLoading;

  CartDetailState({this.cart, this.telemetry, this.isLoading = false});

  factory CartDetailState.initial() => CartDetailState();

  CartDetailState copyWith(
      {Cart? cart, Telemetry? telemetry, bool? isLoading}) {
    return CartDetailState(
      cart: cart ?? this.cart,
      telemetry: telemetry ?? this.telemetry,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Provider
final cartDetailControllerProvider =
    StateNotifierProvider.family<CartDetailController, CartDetailState, String>(
        (ref, cartId) {
  return CartDetailController(ref);
});
