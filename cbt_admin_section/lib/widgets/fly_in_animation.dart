import 'package:flutter/material.dart';

// ADD THIS AT THE BOTTOM OF YOUR FILE
class FlyInAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final AnimationController controller;

  const FlyInAnimation({
    super.key,
    required this.child,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate staggered delays. Card 0 starts at 0.0, Card 1 at 0.15, etc.
    final double start = (index * 0.15).clamp(0.0, 1.0);
    final double end = (start + 0.5).clamp(0.0, 1.0);

    // Fade from invisible (0) to fully visible (1)
    final Animation<double> fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

    // Slide from slightly below (Y: 0.2) to resting position (Y: 0)
    final Animation<Offset> slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }
}
