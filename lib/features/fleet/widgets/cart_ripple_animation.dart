import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Ripple animation widget for selected cart on map
///
/// Displays 3 expanding circles with fading opacity over 5 seconds
class CartRippleAnimation extends StatefulWidget {
  final LatLng position;

  const CartRippleAnimation({
    super.key,
    required this.position,
  });

  @override
  State<CartRippleAnimation> createState() => _CartRippleAnimationState();
}

class _CartRippleAnimationState extends State<CartRippleAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _radiusAnimations;
  late List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();

    // Create 3 animation controllers with staggered start
    _controllers = List.generate(3, (index) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );

      // Start each controller with 500ms delay
      Future.delayed(Duration(milliseconds: index * 500), () {
        if (mounted) {
          controller.repeat();
        }
      });

      return controller;
    });

    // Radius animations: 0 → 60
    _radiusAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 60.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    // Opacity animations: 0.6 → 0.0
    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.6, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Center(
              child: Container(
                width: _radiusAnimations[index].value * 2,
                height: _radiusAnimations[index].value * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: IndustrialDarkTokens.accentPrimary
                        .withOpacity(_opacityAnimations[index].value),
                    width: 2.0,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
