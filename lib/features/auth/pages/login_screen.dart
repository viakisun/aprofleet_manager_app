import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_input.dart';
import '../../../core/widgets/via/via_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/cart_icon.dart';

/// Modern login screen with glass morphism design
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate login delay
    await Future.delayed(const Duration(milliseconds: 800));

    await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      context.go('/rt/map');
    }

    setState(() {
      _isLoading = false;
    });
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
            child: Column(
              children: [
                const SizedBox(height: 64),

                // Logo section
                _buildLogoSection(),

                const SizedBox(height: 64),

                // Login form
                _buildLoginForm(),

                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App icon with custom cart icon
        Container(
          width: 100,
          height: 100,
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
                color: IndustrialDarkTokens.statusActive.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: CartIcon(
              size: 65,
              color: Colors.white,
              showDirection: true,
            ),
          ),
        ),

        const SizedBox(height: IndustrialDarkTokens.spacingCard),

        // App name
        const Text(
          'APRO FLEET',
          style: TextStyle(
            fontFamily: 'Pretendard Variable',
            fontSize: 28,
            fontWeight: IndustrialDarkTokens.fontWeightBold,
            color: IndustrialDarkTokens.textPrimary,
            letterSpacing: IndustrialDarkTokens.letterSpacing,
          ),
        ),

        const SizedBox(height: IndustrialDarkTokens.spacingCompact),

        // Welcome message
        const Text(
          '시스템에 로그인하세요',
          style: TextStyle(
            fontFamily: 'Pretendard Variable',
            fontSize: IndustrialDarkTokens.fontSizeBody,
            fontWeight: IndustrialDarkTokens.fontWeightRegular,
            color: IndustrialDarkTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
      decoration: IndustrialDarkTokens.getGlassMorphismDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            ViaInput.email(
              controller: _emailController,
              label: '이메일',
              placeholder: '이메일을 입력하세요',
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingCard),

            // Password field
            ViaInput.password(
              controller: _passwordController,
              label: '비밀번호',
              placeholder: '비밀번호를 입력하세요',
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

            // Login button
            ViaButton.primary(
              text: '로그인',
              onPressed: _isLoading ? null : _login,
              isLoading: _isLoading,
              isFullWidth: true,
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingCard),

            // Guest login option
            ViaButton.ghost(
              text: '게스트로 계속하기',
              onPressed: _isLoading ? null : _login,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
