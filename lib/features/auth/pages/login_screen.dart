import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_tokens.dart';
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
  bool _obscurePassword = true;

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
      backgroundColor: DesignTokens.bgPrimary,
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
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            child: Column(
              children: [
                const SizedBox(height: DesignTokens.spacing3xl),
                
                // Logo section
                _buildLogoSection(),
                
                const SizedBox(height: DesignTokens.spacing3xl),
                
                // Login form
                _buildLoginForm(),
                
                const SizedBox(height: DesignTokens.spacing3xl),
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
                DesignTokens.statusActive,
                DesignTokens.statusCharging,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: DesignTokens.statusActive.withValues(alpha: 0.3),
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
        
        const SizedBox(height: DesignTokens.spacingLg),
        
        // App name
        Text(
          'APRO FLEET',
          style: TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fontSize3xl,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimary,
            letterSpacing: DesignTokens.letterSpacingWide,
          ),
        ),
        
        const SizedBox(height: DesignTokens.spacingSm),
        
        // Welcome message
        Text(
          '시스템에 로그인하세요',
          style: TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightNormal,
            color: DesignTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: DesignTokens.getGlassMorphismDecoration(
        borderRadius: DesignTokens.radiusLg,
        opacity: 0.1,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            _buildTextField(
              controller: _emailController,
              label: '이메일',
              hint: '이메일을 입력하세요',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
            
            const SizedBox(height: DesignTokens.spacingLg),
            
            // Password field
            _buildTextField(
              controller: _passwordController,
              label: '비밀번호',
              hint: '비밀번호를 입력하세요',
              obscureText: _obscurePassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingXl),
            
            // Login button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.statusActive,
                  foregroundColor: DesignTokens.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: DesignTokens.textDisabled,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        '로그인',
                        style: TextStyle(
                          fontFamily: DesignTokens.fontFamily,
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightSemibold,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingLg),
            
            // Guest login option
            TextButton(
              onPressed: _isLoading ? null : _login,
              child: Text(
                '게스트로 계속하기',
                style: TextStyle(
                  fontFamily: DesignTokens.fontFamily,
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textSecondary,
            letterSpacing: DesignTokens.letterSpacingWide,
          ),
        ),
        
        const SizedBox(height: DesignTokens.spacingSm),
        
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            fontFamily: DesignTokens.fontFamily,
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightNormal,
            color: DesignTokens.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: DesignTokens.fontFamily,
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightNormal,
              color: DesignTokens.textTertiary,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: DesignTokens.textSecondary,
                    size: DesignTokens.iconMd,
                  )
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: DesignTokens.bgSecondary.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              borderSide: BorderSide(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              borderSide: BorderSide(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              borderSide: BorderSide(
                color: DesignTokens.statusActive,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingMd,
            ),
          ),
        ),
      ],
    );
  }
}
