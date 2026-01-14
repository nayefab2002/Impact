import 'package:flutter/material.dart';


Route createSlideRoute(
  Widget page, {
  Offset beginOffset = const Offset(1.0, 0.0),
  bool withFade = true,
  Curve curve = Curves.easeOutQuart,
  Duration duration = const Duration(milliseconds: 350),
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide animation
      final slideTween = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      );
      final slideAnimation = slideTween.animate(
        CurvedAnimation(parent: animation, curve: curve),
      );

      // Fade animation (only if enabled)
      final fadeAnimation = withFade
          ? Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(0.3, 1.0, curve: curve),
              ),
            )
          : AlwaysStoppedAnimation(1.0);

      return withFade
          ? SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            )
          : SlideTransition(
              position: slideAnimation,
              child: child,
            );
    },
    transitionDuration: duration,
    reverseTransitionDuration: Duration(milliseconds: duration.inMilliseconds ~/ 1.5),
    opaque: false,
    fullscreenDialog: false,
  );
}

/// Predefined slide directions for common use cases
class SlideDirections {
  static const fromRight = Offset(1.0, 0.0);
  static const fromLeft = Offset(-1.0, 0.0);
  static const fromTop = Offset(0.0, -1.0);
  static const fromBottom = Offset(0.0, 1.0);
  static const fromTopRight = Offset(1.0, -1.0);
}

/// Predefined animation durations
class AnimationDurations {
  static const fast = Duration(milliseconds: 250);
  static const normal = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 500);
}

/// Predefined animation curves
class AnimationCurves {
  static const standard = Curves.easeOutQuart;
  static const elastic = Curves.elasticOut;
  static const bounce = Curves.bounceOut;
}