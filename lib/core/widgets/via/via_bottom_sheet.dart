import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Bottom Sheet Component
///
/// Draggable bottom sheet with:
/// - Snap points for different heights
/// - Drag handle indicator
/// - Smooth animations
/// - Optional header and footer
/// - Close on backdrop tap
///
/// Features:
/// - Haptic feedback on snap
/// - Outline-based depth (no shadows)
/// - Customizable snap points

class ViaBottomSheet extends StatefulWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final List<double> snapPoints; // Heights as fraction of screen (0.0 to 1.0)
  final int initialSnapIndex;
  final bool isDraggable;
  final bool showDragHandle;
  final bool closeOnBackdropTap;
  final VoidCallback? onClose;
  final ValueChanged<int>? onSnapIndexChanged;
  final Color? backgroundColor;
  final bool enableHaptic;

  const ViaBottomSheet({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.snapPoints = const [0.3, 0.6, 0.9],
    this.initialSnapIndex = 0,
    this.isDraggable = true,
    this.showDragHandle = true,
    this.closeOnBackdropTap = true,
    this.onClose,
    this.onSnapIndexChanged,
    this.backgroundColor,
    this.enableHaptic = true,
  });

  @override
  State<ViaBottomSheet> createState() => _ViaBottomSheetState();

  /// Show VIA bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Widget? header,
    Widget? footer,
    List<double> snapPoints = const [0.5, 0.9],
    int initialSnapIndex = 0,
    bool isDraggable = true,
    bool showDragHandle = true,
    bool closeOnBackdropTap = true,
    Color? backgroundColor,
    bool enableHaptic = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ViaBottomSheet(
        snapPoints: snapPoints,
        initialSnapIndex: initialSnapIndex,
        isDraggable: isDraggable,
        showDragHandle: showDragHandle,
        closeOnBackdropTap: closeOnBackdropTap,
        backgroundColor: backgroundColor,
        enableHaptic: enableHaptic,
        header: header,
        footer: footer,
        onClose: () => Navigator.of(context).pop(),
        child: child,
      ),
    );
  }
}

class _ViaBottomSheetState extends State<ViaBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _currentSnapIndex;
  double _dragOffset = 0.0;
  double _screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _currentSnapIndex = widget.initialSnapIndex;
    _controller = AnimationController(
      duration: IndustrialDarkTokens.durationMedium,
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.isDraggable) return;

    setState(() {
      _dragOffset -= details.primaryDelta ?? 0;
      _dragOffset = _dragOffset.clamp(
        0.0,
        _screenHeight * (widget.snapPoints.last - widget.snapPoints.first),
      );
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.isDraggable) return;

    final velocity = details.primaryVelocity ?? 0;
    final currentHeight = _getCurrentHeight();
    final currentFraction = currentHeight / _screenHeight;

    // Find nearest snap point
    int targetSnapIndex = _currentSnapIndex;
    double minDistance = double.infinity;

    for (int i = 0; i < widget.snapPoints.length; i++) {
      final distance = (widget.snapPoints[i] - currentFraction).abs();
      if (distance < minDistance) {
        minDistance = distance;
        targetSnapIndex = i;
      }
    }

    // Adjust based on velocity
    if (velocity < -500 && targetSnapIndex < widget.snapPoints.length - 1) {
      targetSnapIndex++;
    } else if (velocity > 500 && targetSnapIndex > 0) {
      targetSnapIndex--;
    }

    // Close if dragged down below threshold
    if (velocity > 500 && targetSnapIndex == 0 && currentFraction < 0.15) {
      _close();
      return;
    }

    _snapToIndex(targetSnapIndex);
  }

  void _snapToIndex(int index) {
    if (index == _currentSnapIndex && _dragOffset == 0) return;

    setState(() {
      _currentSnapIndex = index;
      _dragOffset = 0.0;
    });

    if (widget.enableHaptic) {
      HapticFeedback.mediumImpact();
    }

    widget.onSnapIndexChanged?.call(_currentSnapIndex);
  }

  double _getCurrentHeight() {
    final baseHeight = _screenHeight * widget.snapPoints[_currentSnapIndex];
    return baseHeight + _dragOffset;
  }

  void _close() {
    _controller.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.closeOnBackdropTap ? _close : null,
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {}, // Prevent backdrop tap when tapping sheet
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: IndustrialDarkTokens.curveStandard,
                  )),
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: Container(
                height: _getCurrentHeight(),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ??
                      IndustrialDarkTokens.bgSurface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(IndustrialDarkTokens.radiusCard),
                    topRight: Radius.circular(IndustrialDarkTokens.radiusCard),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: IndustrialDarkTokens.outline,
                      width: IndustrialDarkTokens.borderWidth, // 2px
                    ),
                  ),
                  // NO boxShadow in Industrial Dark - outline-based depth only
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    if (widget.showDragHandle)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: IndustrialDarkTokens.spacingItem,
                          bottom: IndustrialDarkTokens.spacingCompact,
                        ),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: IndustrialDarkTokens.textSecondary
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),

                    // Header
                    if (widget.header != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: IndustrialDarkTokens.spacingCard,
                          vertical: IndustrialDarkTokens.spacingItem,
                        ),
                        child: widget.header!,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: IndustrialDarkTokens.outline,
                      ),
                    ],

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
                        child: widget.child,
                      ),
                    ),

                    // Footer
                    if (widget.footer != null) ...[
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: IndustrialDarkTokens.outline,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
                        child: widget.footer!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// VIA Bottom Sheet with snap point indicators
class ViaBottomSheetWithIndicators extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final List<double> snapPoints;
  final int currentSnapIndex;
  final ValueChanged<int>? onSnapIndexChanged;
  final VoidCallback? onClose;

  const ViaBottomSheetWithIndicators({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.snapPoints = const [0.3, 0.6, 0.9],
    this.currentSnapIndex = 0,
    this.onSnapIndexChanged,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ViaBottomSheet(
      snapPoints: snapPoints,
      initialSnapIndex: currentSnapIndex,
      onSnapIndexChanged: onSnapIndexChanged,
      onClose: onClose,
      header: Column(
        children: [
          if (header != null) header!,
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          // Snap point indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              snapPoints.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: IndustrialDarkTokens.spacingMinimal,
                ),
                child: GestureDetector(
                  onTap: () => onSnapIndexChanged?.call(index),
                  child: AnimatedContainer(
                    duration: IndustrialDarkTokens.durationFast,
                    width: index == currentSnapIndex ? 24 : 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: index == currentSnapIndex
                          ? IndustrialDarkTokens.accentPrimary
                          : IndustrialDarkTokens.textSecondary.withValues(alpha: 0.3),
                      borderRadius:
                          BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      footer: footer,
      child: child,
    );
  }
}
