import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../domain/models/cart.dart';

class MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onCenter;
  final VoidCallback? onLayers;

  const MapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onCenter,
    this.onLayers,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: DesignTokens.spacingMd,
      bottom: 120, // Above status bar
      child: Column(
        children: [
          // Zoom In
          _buildControlButton(
            icon: Icons.add,
            onPressed: onZoomIn,
          ),

          const SizedBox(height: DesignTokens.spacingXs),

          // Zoom Out
          _buildControlButton(
            icon: Icons.remove,
            onPressed: onZoomOut,
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Center Map
          _buildControlButton(
            icon: Icons.my_location,
            onPressed: onCenter,
          ),

          const SizedBox(height: DesignTokens.spacingXs),

          // Layers
          _buildControlButton(
            icon: Icons.layers,
            onPressed: onLayers,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: DesignTokens.getGlassMorphismDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: Center(
            child: Icon(
              icon,
              color: DesignTokens.textPrimary,
              size: DesignTokens.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}

class MiniMapOverview extends StatelessWidget {
  final VoidCallback? onTap;

  const MiniMapOverview({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: DesignTokens.spacingMd,
      bottom: DesignTokens.spacingMd,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          height: 80,
          decoration: DesignTokens.getGlassMorphismDecoration(),
          child: Stack(
            children: [
              // Mini map background
              Container(
                decoration: BoxDecoration(
                  gradient: DesignTokens.getMapGradient(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(DesignTokens.radiusMd),
                  ),
                ),
              ),

              // Grid overlay
              CustomPaint(
                size: const Size(120, 80),
                painter: MiniMapGridPainter(),
              ),

              // Center indicator
              Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: DesignTokens.statusActive,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Corner indicator
              Positioned(
                top: DesignTokens.spacingXs,
                right: DesignTokens.spacingXs,
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingXs),
                  decoration: BoxDecoration(
                    color: DesignTokens.bgPrimary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXs),
                  ),
                  child: Text(
                    'MAP',
                    style: DesignTokens.getUppercaseLabelStyle(
                      fontSize: DesignTokens.fontSizeXs,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignTokens.textPrimary.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += size.width / 4) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += size.height / 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapLegend extends StatelessWidget {
  final Map<String, int> statusCounts;
  final Map<String, bool> statusVisibility;
  final Function(String, bool) onStatusToggle;

  const MapLegend({
    super.key,
    required this.statusCounts,
    required this.statusVisibility,
    required this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: DesignTokens.spacingMd,
      bottom: 120, // Above status bar
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: DesignTokens.getGlassMorphismDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LEGEND',
              style: DesignTokens.getUppercaseLabelStyle(
                fontSize: DesignTokens.fontSizeSm,
                color: DesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            ...CartStatus.values.map((status) {
              final count = statusCounts[status.name] ?? 0;
              final isVisible = statusVisibility[status.name] ?? true;
              final color = DesignTokens.getStatusColor(status.name);

              return Padding(
                padding: const EdgeInsets.only(bottom: DesignTokens.spacingXs),
                child: GestureDetector(
                  onTap: () => onStatusToggle(status.name, !isVisible),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isVisible ? color : DesignTokens.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingSm),
                      Text(
                        status.displayName,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: isVisible
                              ? DesignTokens.textPrimary
                              : DesignTokens.textTertiary,
                          fontWeight: DesignTokens.fontWeightMedium,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Text(
                        '($count)',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXs,
                          color: DesignTokens.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
