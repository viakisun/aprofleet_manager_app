import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MarkerOverlayTag extends StatefulWidget {
  final GoogleMapController? controller;
  final LatLng position;
  final Widget child;

  const MarkerOverlayTag({
    super.key,
    required this.controller,
    required this.position,
    required this.child,
  });

  @override
  State<MarkerOverlayTag> createState() => _MarkerOverlayTagState();
}

class _MarkerOverlayTagState extends State<MarkerOverlayTag> {
  Offset screen = Offset.zero;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _recalc();
    _startPeriodicUpdate();
  }

  @override
  void didUpdateWidget(MarkerOverlayTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position || oldWidget.controller != widget.controller) {
      _recalc();
    }
  }

  void _startPeriodicUpdate() {
    _updateTimer?.cancel();
    // Use longer interval for better performance
    _updateTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        _recalc();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _recalc() async {
    if (widget.controller == null) {
      print('MarkerOverlayTag: Controller is null');
      return;
    }

    try {
      print('MarkerOverlayTag: Getting screen coordinate for position: ${widget.position}');
      final sc = await widget.controller!.getScreenCoordinate(widget.position);
      if (mounted) {
        final newScreen = Offset(sc.x.toDouble(), sc.y.toDouble());
        print('MarkerOverlayTag: Screen coordinate = $newScreen');
        print('MarkerOverlayTag: Calculated position - dx: ${newScreen.dx + 12}, dy: ${newScreen.dy - 32}');
        setState(() => screen = newScreen);
      }
    } catch (e) {
      print('MarkerOverlayTag: Error getting screen coordinate: $e');
      if (mounted) {
        setState(() => screen = Offset.zero);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dx = screen.dx + 12;
    final dy = screen.dy - 32;

    // 화면 밖으로 나가지 않도록 제한
    final screenSize = MediaQuery.of(context).size;
    final clampedDx = dx.clamp(0.0, screenSize.width - 100);
    final clampedDy = dy.clamp(0.0, screenSize.height - 50);

    print('MarkerOverlayTag: Final position - dx: $clampedDx, dy: $clampedDy');

    return Positioned(
      left: clampedDx,
      top: clampedDy,
      child: AnimatedOpacity(
        opacity: screen == Offset.zero ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}
