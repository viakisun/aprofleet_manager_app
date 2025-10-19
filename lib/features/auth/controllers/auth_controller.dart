import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication controller for managing app state and user flow
class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState()) {
    _initializeAuth();
  }

  /// Initialize authentication state from shared preferences
  Future<void> _initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 온보딩을 매번 표시할지 여부 설정 (개발/테스트 목적으로 true)
    const bool alwaysShowOnboarding = true;
    
    final hasSeenOnboarding = alwaysShowOnboarding ? false : (prefs.getBool('has_seen_onboarding') ?? false);
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    state = state.copyWith(
      hasSeenOnboarding: hasSeenOnboarding,
      isLoggedIn: isLoggedIn,
      isLoading: false,
    );
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    state = state.copyWith(hasSeenOnboarding: true);
  }

  /// Login user (no validation required)
  Future<void> login({String? email, String? password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    
    state = state.copyWith(isLoggedIn: true);
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    
    state = state.copyWith(isLoggedIn: false);
  }

  /// Reset app state (for testing/debugging)
  Future<void> resetAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_seen_onboarding');
    await prefs.remove('is_logged_in');
    
    state = const AuthState();
  }
}

/// Authentication state model
class AuthState {
  final bool hasSeenOnboarding;
  final bool isLoggedIn;
  final bool isLoading;

  const AuthState({
    this.hasSeenOnboarding = false,
    this.isLoggedIn = false,
    this.isLoading = true,
  });

  AuthState copyWith({
    bool? hasSeenOnboarding,
    bool? isLoggedIn,
    bool? isLoading,
  }) {
    return AuthState(
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for authentication controller
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});
