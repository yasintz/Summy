import 'package:flutter/material.dart';

class Responsive {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width * (p / 100);
  }

  static height(double p, BuildContext context) {
    return (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom) *
        (p / 100);
  }
}
