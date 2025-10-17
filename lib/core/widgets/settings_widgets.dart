import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';

/// User profile widget for settings menu
class UserProfileWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;

  const UserProfileWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    this.avatarUrl,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: DesignTokens.bgSecondary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: DesignTokens.borderPrimary,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: DesignTokens.statusActive,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: DesignTokens.borderSecondary,
                  width: 1.0,
                ),
              ),
              child: avatarUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildInitialsAvatar(),
                      ),
                    )
                  : _buildInitialsAvatar(),
            ),

            const SizedBox(width: DesignTokens.spacingMd),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeLg,
                      fontWeight: DesignTokens.fontWeightSemibold,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeSm,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: DesignTokens.textTertiary,
              size: DesignTokens.iconMd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    final initials = userName.isNotEmpty
        ? userName
            .split(' ')
            .map((e) => e.isNotEmpty ? e[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : 'U';

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeLg,
          fontWeight: DesignTokens.fontWeightBold,
          color: DesignTokens.bgPrimary,
        ),
      ),
    );
  }
}

/// Menu item widget for settings
class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showDivider;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingMd,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DesignTokens.bgTertiary,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    border: Border.all(
                      color: DesignTokens.borderPrimary,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: DesignTokens.iconSm,
                    color: iconColor ?? DesignTokens.textSecondary,
                  ),
                ),

                const SizedBox(width: DesignTokens.spacingMd),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightMedium,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing widget or chevron
                if (trailing != null)
                  trailing!
                else
                  Icon(
                    Icons.chevron_right,
                    color: DesignTokens.textTertiary,
                    size: DesignTokens.iconMd,
                  ),
              ],
            ),
          ),
        ),

        // Divider
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
            child: Divider(
              height: 1,
              color: DesignTokens.borderPrimary,
            ),
          ),
      ],
    );
  }
}

/// Settings section widget
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: DesignTokens.textSecondary,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
        ),

        // Section content
        Container(
          decoration: BoxDecoration(
            color: DesignTokens.bgSecondary,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(
              color: DesignTokens.borderPrimary,
              width: 1.0,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
