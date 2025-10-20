import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.radius = 14,
    this.blurSigma = 12,
    this.bgOpacity = 0.75, // 적절한 불투명도
    this.borderOpacity = 0.12, // 12% white divider
    this.padding,
  });

  final Widget child;
  final double radius;
  final double blurSigma;
  final double bgOpacity;
  final double borderOpacity;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final divider = Colors.white.withOpacity(borderOpacity);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(bgOpacity),
            border: Border.all(color: divider, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}