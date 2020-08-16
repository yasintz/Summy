import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;

  const PageWrapper({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: SafeArea(
        child: child,
      ),
    );
  }
}
