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
          child: Padding(
            padding: const EdgeInsets.only(top: 250),
            child: Column(
              children: [
                FlatButton(
                  onPressed: () {
                    PageNavigator.of(context).push(
                      route: Routes.Game,
                      animation: RouteAnimation.SCALE,
                    );
                  },
                  child: Text("Go to Game"),
                ),
                FlatButton(
                  onPressed: () {
                    PageNavigator.of(context).push(
                      route: Routes.Settings,
                      animation: RouteAnimation.SCALE,
                    );
                  },
                  child: Text("Go to Settings"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
