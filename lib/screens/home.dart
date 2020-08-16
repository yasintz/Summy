import 'package:flutter/material.dart';
import 'package:summy/components/page_wrapper.dart';
import 'package:summy/services/page_navigator/page_navigator.dart';
import 'package:summy/services/page_navigator/route_animation.dart';
import 'package:summy/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Container(
        child: Center(
          child: FlatButton(
            onPressed: () {
              PageNavigator.of(context).push(
                route: Routes.Game,
                animation: RouteAnimation.SCALE,
              );
            },
            child: Text("Go to Game"),
          ),
        ),
      ),
    );
  }
}
