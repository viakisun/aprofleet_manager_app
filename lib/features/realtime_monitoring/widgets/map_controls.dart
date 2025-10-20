import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

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
      right: DesignTokens.spacingMd,
      top: DesignTokens.spacingMd,
      child: Column(
        children: [
          Tooltip(
            message: 'Zoom in (+)',
            child: FloatingActionButton.small(
              heroTag: 'zoom_in',
              onPressed: onZoomIn,
              backgroundColor: DesignTokens.bgSecondary.withValues(alpha: 0.8),
              child: const Icon(Icons.add, color: DesignTokens.textPrimary),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Tooltip(
            message: 'Zoom out (−)',
            child: FloatingActionButton.small(
              heroTag: 'zoom_out',
              onPressed: onZoomOut,
              backgroundColor: DesignTokens.bgSecondary.withValues(alpha: 0.8),
              child: const Icon(Icons.remove, color: DesignTokens.textPrimary),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Tooltip(
            message: 'Tone (T)',
            child: FloatingActionButton.small(
              heroTag: 'tone_control',
              onPressed: onToneToggle,
              backgroundColor: DesignTokens.bgSecondary.withValues(alpha: 0.8),
              child: const Icon(Icons.palette, color: DesignTokens.textPrimary),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Tooltip(
            message: isSatelliteUI ? 'Layer: Satellite (L)' : 'Layer: Standard (L)',
            child: FloatingActionButton.small(
              heroTag: 'layer_toggle',
              onPressed: onLayerToggle,
              backgroundColor: DesignTokens.bgSecondary.withValues(alpha: 0.8),
              child: Icon(
                isSatelliteUI ? Icons.layers : Icons.layers_clear,
                color: DesignTokens.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Tooltip(
            message: 'My location',
            child: FloatingActionButton.small(
              heroTag: 'my_location',
              onPressed: onMyLocation,
              backgroundColor: DesignTokens.bgSecondary.withValues(alpha: 0.8),
              child: const Icon(Icons.my_location, color: DesignTokens.textPrimary),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Tooltip(
            message: 'Fullscreen (F)',
            child: FloatingActionButton.small(
              heroTag: 'fullscreen',
              onPressed: onFullscreen,
              backgroundColor: DesignTokens.bgSecondary.withValues(alpha: 0.8),
              child: const Icon(Icons.fullscreen, color: DesignTokens.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}