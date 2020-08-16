import 'package:flutter/material.dart';
import 'package:summy/services/page_navigator/route_animation.dart';
import 'package:summy/routes.dart';

Route _createRoute({
  @required WidgetBuilder builder,
  RouteAnimation animation,
}) {
  RouteAnimation animationType = animation;
  if (animationType == null) {
    animationType = RouteAnimation.BASE;
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: routeAnimation[animationType.toString()],
  );
}

class PageNavigator {
  final BuildContext context;
  PageNavigator(this.context);

  static PageNavigator of(BuildContext ctx) {
    return PageNavigator(ctx);
  }

  WidgetBuilder _getWidgetBuilder(Routes route) {
    return routes[route.toString()];
  }

  Future<T> push<T>({
    @required Routes route,
    RouteAnimation animation,
  }) {
    return Navigator.of(this.context).push<T>(
      _createRoute(
        builder: _getWidgetBuilder(route),
        animation: animation,
      ),
    );
  }

  Future<T> replace<T>({
    @required Routes route,
    RouteAnimation animation,
  }) {
    NavigatorState navigator = Navigator.of(this.context);

    navigator.pop();

    return navigator.push(
      _createRoute(
        builder: _getWidgetBuilder(route),
        animation: animation,
      ),
    );
  }

  void pop() {
    NavigatorState navigator = Navigator.of(this.context);

    return navigator.pop();
  }
}
