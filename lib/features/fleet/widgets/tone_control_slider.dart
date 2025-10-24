import 'package:flutter/material.dart';
import '../../../core/theme/industrial_dark_tokens.dart';

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
          horizontal: IndustrialDarkTokens.spacingItem,
          vertical: IndustrialDarkTokens.spacingCompact,
        ),
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgSurface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          border: Border.all(
            color: IndustrialDarkTokens.outline,
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
              style: IndustrialDarkTokens.labelStyle.copyWith(
                color: IndustrialDarkTokens.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: IndustrialDarkTokens.letterSpacing,
              ),
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            SizedBox(
              height: 120,
              width: 40,
              child: RotatedBox(
                quarterTurns: 3,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: IndustrialDarkTokens.accentPrimary,
                    inactiveTrackColor: IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.2),
                    thumbColor: IndustrialDarkTokens.accentPrimary,
                    overlayColor: IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.2),
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
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: IndustrialDarkTokens.spacingCompact,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              ),
              child: Text(
                '${(mapOpacity * 100).round()}%',
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  color: IndustrialDarkTokens.accentPrimary,
                  fontSize: 10,
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

