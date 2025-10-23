import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Input Component
///
/// Glass-style text input with:
/// - Glass background with subtle blur effect
/// - Focused state with VIA primary color glow
/// - Error state with red glow and shake animation
/// - Password toggle with visibility icon
/// - Prefix/suffix icon support
/// - Character counter
/// - Helper/error text
///
/// Features:
/// - Smooth focus/error animations
/// - Haptic feedback on interaction
/// - Integration with VIA design tokens
enum ViaInputType {
  text,
  email,
  password,
  number,
  phone,
  multiline,
}

class ViaInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ViaInputType inputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool enabled;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableHaptic;
  final bool autofocus;

  const ViaInput({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.inputType = ViaInputType.text,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.enableHaptic = true,
    this.autofocus = false,
  });

  /// Email input
  const ViaInput.email({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon = Icons.email_outlined,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.enableHaptic = true,
    this.autofocus = false,
  })  : inputType = ViaInputType.email,
        maxLines = 1,
        minLines = null;

  /// Password input with visibility toggle
  const ViaInput.password({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon = Icons.lock_outline,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.enableHaptic = true,
    this.autofocus = false,
  })  : inputType = ViaInputType.password,
        suffixIcon = null,
        onSuffixIconTap = null,
        maxLines = 1,
        minLines = null;

  /// Phone number input
  const ViaInput.phone({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon = Icons.phone_outlined,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.enableHaptic = true,
    this.autofocus = false,
  })  : inputType = ViaInputType.phone,
        maxLines = 1,
        minLines = null;

  /// Multiline text input (textarea)
  const ViaInput.multiline({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 5,
    this.minLines = 3,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.enableHaptic = true,
    this.autofocus = false,
  }) : inputType = ViaInputType.multiline;

  @override
  State<ViaInput> createState() => _ViaInputState();
}

class _ViaInputState extends State<ViaInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _obscureText = true;
  bool _isFocused = false;
  String? _previousErrorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    // Shake animation for error state
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void didUpdateWidget(ViaInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake animation when error appears
    if (widget.errorText != null &&
        widget.errorText != _previousErrorText &&
        _previousErrorText == null) {
      _triggerShake();
    }
    _previousErrorText = widget.errorText;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused && widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0).then((_) {
      _shakeController.reverse();
    });
    if (widget.enableHaptic) {
      HapticFeedback.mediumImpact();
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
    if (widget.enableHaptic) {
      HapticFeedback.selectionClick();
    }
  }

  TextInputType _getKeyboardType() {
    // Use explicit keyboardType if provided
    if (widget.keyboardType != null) {
      return widget.keyboardType!;
    }

    // Otherwise use inputType
    switch (widget.inputType) {
      case ViaInputType.email:
        return TextInputType.emailAddress;
      case ViaInputType.number:
        return TextInputType.number;
      case ViaInputType.phone:
        return TextInputType.phone;
      case ViaInputType.multiline:
        return TextInputType.multiline;
      case ViaInputType.password:
      case ViaInputType.text:
        return TextInputType.text;
    }
  }

  Color _getBorderColor() {
    if (widget.errorText != null) {
      return ViaDesignTokens.critical;
    }
    if (_isFocused) {
      return ViaDesignTokens.primary;
    }
    return ViaDesignTokens.borderPrimary;
  }

  Color _getGlowColor() {
    if (widget.errorText != null) {
      return ViaDesignTokens.critical.withValues(alpha: 0.3);
    }
    if (_isFocused) {
      return ViaDesignTokens.primary.withValues(alpha: 0.3);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: hasError
              ? Offset(_shakeAnimation.value *
                  ((_shakeController.value * 2 - 1).sign), 0)
              : Offset.zero,
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: ViaDesignTokens.labelMedium.copyWith(
                color: hasError
                    ? ViaDesignTokens.critical
                    : ViaDesignTokens.textSecondary,
              ),
            ),
            const SizedBox(height: ViaDesignTokens.spacingSm),
          ],

          // Input field with glass effect and glow
          AnimatedContainer(
            duration: ViaDesignTokens.durationFast,
            decoration: BoxDecoration(
              // Glass background
              color: ViaDesignTokens.surfaceSecondary,
              borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
              border: Border.all(
                color: _getBorderColor(),
                width: _isFocused || hasError ? 1.5 : 1.0,
              ),
              // Glow effect
              boxShadow: [
                BoxShadow(
                  color: _getGlowColor(),
                  blurRadius: _isFocused || hasError ? 12.0 : 0.0,
                  spreadRadius: _isFocused || hasError ? 2.0 : 0.0,
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              obscureText:
                  widget.inputType == ViaInputType.password && _obscureText,
              keyboardType: _getKeyboardType(),
              textInputAction: widget.textInputAction,
              maxLength: widget.maxLength,
              maxLines: widget.inputType == ViaInputType.password
                  ? 1
                  : (widget.maxLines ?? 1),
              minLines: widget.minLines,
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: widget.onSubmitted,
              style: ViaDesignTokens.bodyMedium.copyWith(
                color: widget.enabled
                    ? ViaDesignTokens.textPrimary
                    : ViaDesignTokens.textDisabled,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: ViaDesignTokens.bodyMedium.copyWith(
                  color: ViaDesignTokens.textMuted,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: hasError
                            ? ViaDesignTokens.critical
                            : (_isFocused
                                ? ViaDesignTokens.primary
                                : ViaDesignTokens.textMuted),
                        size: ViaDesignTokens.iconSm,
                      )
                    : null,
                suffixIcon: _buildSuffixIcon(),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.prefixIcon == null
                      ? ViaDesignTokens.spacingLg
                      : ViaDesignTokens.spacingSm,
                  vertical: ViaDesignTokens.spacingMd,
                ),
                counterText: '', // Hide default counter
              ),
            ),
          ),

          // Helper or error text
          if (widget.helperText != null || hasError) ...[
            const SizedBox(height: ViaDesignTokens.spacingSm),
            Row(
              children: [
                if (hasError) ...[
                  Icon(
                    Icons.error_outline,
                    size: ViaDesignTokens.iconXs,
                    color: ViaDesignTokens.critical,
                  ),
                  const SizedBox(width: ViaDesignTokens.spacingXs),
                ],
                Expanded(
                  child: Text(
                    hasError ? widget.errorText! : widget.helperText!,
                    style: ViaDesignTokens.bodySmall.copyWith(
                      color: hasError
                          ? ViaDesignTokens.critical
                          : ViaDesignTokens.textMuted,
                    ),
                  ),
                ),
                // Character counter
                if (widget.maxLength != null) ...[
                  const SizedBox(width: ViaDesignTokens.spacingSm),
                  Text(
                    '${_controller.text.length}/${widget.maxLength}',
                    style: ViaDesignTokens.bodySmall.copyWith(
                      color: ViaDesignTokens.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // Password visibility toggle
    if (widget.inputType == ViaInputType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: ViaDesignTokens.iconSm,
          color: _isFocused
              ? ViaDesignTokens.primary
              : ViaDesignTokens.textMuted,
        ),
        onPressed: _togglePasswordVisibility,
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: ViaDesignTokens.iconSm,
          color: _isFocused
              ? ViaDesignTokens.primary
              : ViaDesignTokens.textMuted,
        ),
        onPressed: widget.onSuffixIconTap,
      );
    }

    return null;
  }
}
