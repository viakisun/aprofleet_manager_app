import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/cart_icon.dart';

/// Onboarding screen with 3 pages introducing app features
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    const OnboardingPageData(
      icon: Icons.location_on,
      title: '실시간 카트 모니터링',
      description: '모든 골프카트의 실시간 위치와 상태를\n한눈에 확인하고 효율적으로 관리하세요.',
      color: IndustrialDarkTokens.statusActive,
      customIcon: CartIcon(
        size: 80,
        color: Colors.white,
        showDirection: true,
      ),
    ),
    const OnboardingPageData(
      icon: Icons.build_circle,
      title: '유지보수 및 워크오더 관리',
      description: '체계적인 유지보수 계획과\n워크오더 생성으로 관리 효율성을 높이세요.',
      color: IndustrialDarkTokens.statusCharging,
    ),
    const OnboardingPageData(
      icon: Icons.analytics,
      title: '알림 및 분석 리포트',
      description: '데이터 기반의 인사이트로\n더 나은 의사결정을 내리세요.',
      color: IndustrialDarkTokens.accentPrimary,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() async {
    await ref.read(authControllerProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/login');
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IndustrialDarkTokens.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // Header with skip button
            Padding(
              padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (only show if not on first page)
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    )
                  else
                    const SizedBox(width: 48),

                  // Skip button
                  ViaButton.ghost(
                    text: '건너뛰기',
                    onPressed: _skipOnboarding,
                    size: ViaButtonSize.small,
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index]);
                },
              ),
            ),

            // Bottom section with indicators and buttons
            Padding(
              padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildPageIndicator(index == _currentPage),
                    ),
                  ),

                  const SizedBox(height: IndustrialDarkTokens.spacingCard),

                  // Next/Get Started button
                  ViaButton.primary(
                    text: _currentPage == _pages.length - 1 ? '시작하기' : '다음',
                    onPressed: _nextPage,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPageData pageData) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCard),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  pageData.color,
                  pageData.color.withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: pageData.color.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: pageData.customIcon ??
                Icon(
                  pageData.icon,
                  size: 80,
                  color: Colors.white,
                ),
          ),

          const SizedBox(height: 64),

          // Title
          Text(
            pageData.title,
            style: const TextStyle(
              fontFamily: 'Pretendard Variable',
              fontSize: 28,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: IndustrialDarkTokens.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCard),

          // Description
          Text(
            pageData.description,
            style: const TextStyle(
              fontFamily: 'Pretendard Variable',
              fontSize: IndustrialDarkTokens.fontSizeBody,
              fontWeight: IndustrialDarkTokens.fontWeightRegular,
              color: IndustrialDarkTokens.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? IndustrialDarkTokens.statusActive
            : IndustrialDarkTokens.outlineSoft,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Data model for onboarding page content
class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Widget? customIcon;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.customIcon,
  });
}
