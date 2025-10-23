import 'package:flutter/material.dart';
import '../../../core/theme/via_design_tokens.dart';

/// VIA Design System Tone Control Slider
///
/// Vertical slider for map opacity control
class ToneControlSlider extends StatelessWidget {
  final double mapOpacity;
  final ValueChanged<double> onOpacityChanged;

  const ToneControlSlider({
    super.key,
    required this.mapOpacity,
    required this.onOpacityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 80,
      top: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingMd,
          vertical: ViaDesignTokens.spacingSm,
        ),
        decoration: BoxDecoration(
          color: ViaDesignTokens.surfaceSecondary.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          border: Border.all(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TONE',
              style: ViaDesignTokens.labelSmall.copyWith(
                color: ViaDesignTokens.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: ViaDesignTokens.letterSpacingWide,
              ),
            ),
            const SizedBox(height: ViaDesignTokens.spacingSm),
            SizedBox(
              height: 120,
              width: 40,
              child: RotatedBox(
                quarterTurns: 3,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: ViaDesignTokens.primary,
                    inactiveTrackColor: ViaDesignTokens.primary.withValues(alpha: 0.2),
                    thumbColor: ViaDesignTokens.primary,
                    overlayColor: ViaDesignTokens.primary.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: mapOpacity,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: onOpacityChanged,
                  ),
                ),
              ),
            ),
            const SizedBox(height: ViaDesignTokens.spacingXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ViaDesignTokens.spacingXs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: ViaDesignTokens.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ViaDesignTokens.radiusSm),
              ),
              child: Text(
                '${(mapOpacity * 100).round()}%',
                style: ViaDesignTokens.labelSmall.copyWith(
                  color: ViaDesignTokens.primary,
                  fontSize: ViaDesignTokens.fontSizeXxs,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

