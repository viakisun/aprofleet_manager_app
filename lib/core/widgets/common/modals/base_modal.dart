import 'package:flutter/material.dart';
import '../../../theme/design_tokens.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

/// A reusable modal widget with slide-up animation
class BaseModal extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final double? height;
  final bool showHandleBar;
  final bool isDismissible;

  const BaseModal({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.height,
    this.showHandleBar = true,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: DesignTokens.bgTertiary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(DesignTokens.radiusLg),
          topRight: Radius.circular(DesignTokens.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          if (showHandleBar) ...[
            Container(
              margin: const EdgeInsets.only(top: DesignTokens.spacingSm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DesignTokens.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Header
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSizeXl,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
          ],

          // Content
          Flexible(child: child),
        ],
      ),
    );
  }

  /// Show modal with slide-up animation
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
    double? height,
    bool showHandleBar = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => BaseModal(
        title: title,
        actions: actions,
        height: height,
        showHandleBar: showHandleBar,
        isDismissible: isDismissible,
        child: child,
      ),
    );
  }
}

/// A confirmation dialog modal
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: title,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingXl),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: cancelText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: PrimaryButton(
                    text: confirmText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
