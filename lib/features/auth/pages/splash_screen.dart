import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../controllers/auth_controller.dart';
import '../widgets/cart_icon.dart';

/// Splash screen with APRO FLEET branding and animations
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _startSplashSequence() async {
    // Start animations
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();

    // Wait for splash duration and navigate
    await Future.delayed(const Duration(milliseconds: 2000));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    final authState = ref.read(authControllerProvider);

    if (!authState.hasSeenOnboarding) {
      context.go('/onboarding');
    } else if (!authState.isLoggedIn) {
      context.go('/login');
    } else {
      context.go('/rt/map');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IndustrialDarkTokens.bgBase,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF000000),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and branding
              AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          // App icon/logo with custom cart icon
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  IndustrialDarkTokens.statusActive,
                                  IndustrialDarkTokens.statusCharging,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: IndustrialDarkTokens.statusActive
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: CartIcon(
                                size: 80,
                                color: Colors.white,
                                showDirection: true,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: IndustrialDarkTokens.spacingSection),

                          // App name
                          const Text(
                            'APRO FLEET',
                            style: TextStyle(
                              fontFamily: 'Pretendard Variable',
                              fontSize: 32,
                              fontWeight: IndustrialDarkTokens.fontWeightBold,
                              color: IndustrialDarkTokens.textPrimary,
                              letterSpacing: IndustrialDarkTokens.letterSpacing,
                            ),
                          ),

                          const SizedBox(
                              height: IndustrialDarkTokens.spacingCompact),

                          // Subtitle
                          const Text(
                            'Fleet Management System',
                            style: TextStyle(
                              fontFamily: 'Pretendard Variable',
                              fontSize: IndustrialDarkTokens.fontSizeBody,
                              fontWeight: IndustrialDarkTokens.fontWeightMedium,
                              color: IndustrialDarkTokens.textSecondary,
                              letterSpacing: IndustrialDarkTokens.letterSpacing,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 64),

              // Loading indicator
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          IndustrialDarkTokens.statusActive,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
