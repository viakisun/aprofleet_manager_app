import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Input Component
///
/// Professional text input with:
/// - Dark gray background (#222222)
/// - 2px outline on focus (no glow - outline-based depth only)
/// - Error state with red border and shake animation
/// - Password toggle with visibility icon
/// - Prefix/suffix icon support
/// - Character counter
/// - Helper/error text
///
/// Features:
/// - Smooth focus/error animations
/// - Haptic feedback on interaction
/// - Outline-based depth (no shadows)
/// - Integration with Industrial Dark tokens
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
      return IndustrialDarkTokens.error;
    }
    if (_isFocused) {
      return IndustrialDarkTokens.accentPrimary;
    }
    return IndustrialDarkTokens.outline;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: hasError
              ? Offset(
                  _shakeAnimation.value *
                      ((_shakeController.value * 2 - 1).sign),
                  0)
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
              style: IndustrialDarkTokens.labelStyle.copyWith(
                fontSize: IndustrialDarkTokens.fontSizeLabel,
                color: hasError
                    ? IndustrialDarkTokens.error
                    : IndustrialDarkTokens.textSecondary,
              ),
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          ],

          // Input field with outline-based depth (no glow)
          AnimatedContainer(
            duration: IndustrialDarkTokens.durationFast,
            decoration: BoxDecoration(
              // Dark gray background
              color: IndustrialDarkTokens.bgSurface,
              borderRadius:
                  BorderRadius.circular(IndustrialDarkTokens.radiusButton),
              border: Border.all(
                color: _getBorderColor(),
                width: _isFocused || hasError
                    ? IndustrialDarkTokens.borderWidth // 2px
                    : IndustrialDarkTokens.borderWidthThin, // 1px
              ),
              // NO boxShadow in Industrial Dark - outline-based depth only
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
              style: IndustrialDarkTokens.bodyStyle.copyWith(
                fontSize: IndustrialDarkTokens.fontSizeBody,
                color: widget.enabled
                    ? IndustrialDarkTokens.textPrimary
                    : IndustrialDarkTokens.textSecondary.withValues(alpha: 0.3),
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: IndustrialDarkTokens.bodyStyle.copyWith(
                  fontSize: IndustrialDarkTokens.fontSizeBody,
                  color: IndustrialDarkTokens.textSecondary,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: hasError
                            ? IndustrialDarkTokens.error
                            : (_isFocused
                                ? IndustrialDarkTokens.accentPrimary
                                : IndustrialDarkTokens.textSecondary),
                        size: 20,
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
                      ? IndustrialDarkTokens.spacingCard // 16px
                      : IndustrialDarkTokens.spacingCompact, // 8px
                  vertical: IndustrialDarkTokens.spacingItem, // 12px
                ),
                counterText: '', // Hide default counter
              ),
            ),
          ),

          // Helper or error text
          if (widget.helperText != null || hasError) ...[
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Row(
              children: [
                if (hasError) ...[
                  const Icon(
                    Icons.error_outline,
                    size: 16,
                    color: IndustrialDarkTokens.error,
                  ),
                  const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
                ],
                Expanded(
                  child: Text(
                    hasError ? widget.errorText! : widget.helperText!,
                    style: IndustrialDarkTokens.bodyStyle.copyWith(
                      fontSize: IndustrialDarkTokens.fontSizeSmall,
                      color: hasError
                          ? IndustrialDarkTokens.error
                          : IndustrialDarkTokens.textSecondary,
                    ),
                  ),
                ),
                // Character counter
                if (widget.maxLength != null) ...[
                  const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                  Text(
                    '${_controller.text.length}/${widget.maxLength}',
                    style: IndustrialDarkTokens.bodyStyle.copyWith(
                      fontSize: IndustrialDarkTokens.fontSizeSmall,
                      color: IndustrialDarkTokens.textSecondary,
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
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 20,
          color: _isFocused
              ? IndustrialDarkTokens.accentPrimary
              : IndustrialDarkTokens.textSecondary,
        ),
        onPressed: _togglePasswordVisibility,
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: 20,
          color: _isFocused
              ? IndustrialDarkTokens.accentPrimary
              : IndustrialDarkTokens.textSecondary,
        ),
        onPressed: widget.onSuffixIconTap,
      );
    }

    return null;
  }
}
