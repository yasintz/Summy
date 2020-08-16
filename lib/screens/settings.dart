import 'package:flutter/material.dart';
import 'package:summy/component/page_wrapper.dart';
import 'package:summy/lib/page_navigator/page_navigator.dart';
import 'package:summy/routes.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Container(
        child: Center(
          child: FlatButton(
            onPressed: () {
              PageNavigator.of(context).replace(route: Routes.Home);
            },
            child: Text("Go to Home"),
          ),
        ),
      ),
    );
  }
}
