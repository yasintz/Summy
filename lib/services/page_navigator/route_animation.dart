import 'package:flutter/material.dart';

enum RouteAnimation {
  BASE,
  SCALE,
}

Map<String, RouteTransitionsBuilder> routeAnimation = {
  RouteAnimation.BASE.toString(): (ctx, animation, _, child) {
    Offset begin = Offset(0.0, 1.0);
    Offset end = Offset.zero;
    Cubic curve = Curves.ease;
    CurveTween curveTween = CurveTween(curve: curve);

    Animatable<Offset> tween = Tween(begin: begin, end: end).chain(curveTween);

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  },
  RouteAnimation.SCALE.toString(): (ctx, animation, secondaryAnimation, child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: child,
    );
  }
};
