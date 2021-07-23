import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/circlePainter.dart';

class RippleAnimation extends StatefulWidget {
  final double size;
  final Widget child;

  const RippleAnimation({this.size, this.child});

  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this
    )..repeat();
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: CustomPaint(
          painter: CirclePainter(
            animationController,
            color: kSpringColor,
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size),
              child: widget.child
            ),
          ),
        ),
      ),
    );
  }
}