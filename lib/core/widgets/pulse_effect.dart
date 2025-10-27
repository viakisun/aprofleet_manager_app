import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class PulseEffect extends StatefulWidget {
  final Widget child;
  final Color pulseColor;
  final Duration duration;

  const PulseEffect({
    super.key,
    required this.child,
    this.pulseColor = DesignTokens.statusActive,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PulseEffect> createState() => _PulseEffectState();
}

class _PulseEffectState extends State<PulseEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              width: 60 + (_animation.value * 20),
              height: 60 + (_animation.value * 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.pulseColor
                    .withValues(alpha: 0.3 - (_animation.value * 0.2)),
                border: Border.all(
                  color: widget.pulseColor
                      .withValues(alpha: 0.6 - (_animation.value * 0.4)),
                  width: 2,
                ),
              ),
            ),
            // Child widget
            widget.child,
          ],
        );
      },
    );
  }
}
