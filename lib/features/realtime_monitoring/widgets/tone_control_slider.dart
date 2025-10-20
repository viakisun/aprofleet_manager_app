import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: DesignTokens.letterSpacingNormal,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              width: 40,
              child: RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: mapOpacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: onOpacityChanged,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
            Text(
              '${(mapOpacity * 100).round()}%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: DesignTokens.letterSpacingTight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

