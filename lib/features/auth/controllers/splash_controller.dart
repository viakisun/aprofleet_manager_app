import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple controller for splash screen state management
class SplashController extends StateNotifier<SplashState> {
  SplashController() : super(const SplashState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setInitialized(bool initialized) {
    state = state.copyWith(initialized: initialized);
  }
}

/// Splash screen state
class SplashState {
  final bool isLoading;
  final bool initialized;

  const SplashState({
    this.isLoading = true,
    this.initialized = false,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? initialized,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      initialized: initialized ?? this.initialized,
    );
  }
}

/// Provider for splash controller
final splashControllerProvider = StateNotifierProvider<SplashController, SplashState>((ref) {
  return SplashController();
});
