import 'package:flutter/material.dart';
import '../../../core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_icon_button.dart';

/// VIA Design System Map Controls
///
/// Provides map control buttons with VIA styling
class MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onToneToggle;
  final VoidCallback onLayerToggle;
  final VoidCallback onMyLocation;
  final VoidCallback onFullscreen;
  final bool isSatelliteUI;

  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onToneToggle,
    required this.onLayerToggle,
    required this.onMyLocation,
    required this.onFullscreen,
    required this.isSatelliteUI,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: IndustrialDarkTokens.spacingItem,
      top: IndustrialDarkTokens.spacingItem,
      child: Column(
        children: [
          ViaIconButton.ghost(
            icon: Icons.add,
            onPressed: onZoomIn,
            tooltip: 'Zoom in (+)',
            size: ViaIconButtonSize.medium,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          ViaIconButton.ghost(
            icon: Icons.remove,
            onPressed: onZoomOut,
            tooltip: 'Zoom out (−)',
            size: ViaIconButtonSize.medium,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          ViaIconButton.ghost(
            icon: Icons.palette,
            onPressed: onToneToggle,
            tooltip: 'Tone (T)',
            size: ViaIconButtonSize.medium,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          ViaIconButton.ghost(
            icon: isSatelliteUI ? Icons.layers : Icons.layers_clear,
            onPressed: onLayerToggle,
            tooltip:
                isSatelliteUI ? 'Layer: Satellite (L)' : 'Layer: Standard (L)',
            size: ViaIconButtonSize.medium,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          ViaIconButton.ghost(
            icon: Icons.my_location,
            onPressed: onMyLocation,
            tooltip: 'My location',
            size: ViaIconButtonSize.medium,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          ViaIconButton.ghost(
            icon: Icons.fullscreen,
            onPressed: onFullscreen,
            tooltip: 'Fullscreen (F)',
            size: ViaIconButtonSize.medium,
          ),
        ],
      ),
    );
  }
}
