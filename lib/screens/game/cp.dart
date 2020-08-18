import 'package:flutter/material.dart';

import 'package:summy/screens/game/hexagon_button.dart';

class CustomP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CCp(),
      size: Size.infinite,
    );
  }
}

class CCp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Paint()..color = Colors.purple,
    );

    HexagonButton hexagonButton = HexagonButton(
      centralPoint: Offset(100, 100),
      sideLength: 35,
      strokeWidth: 4.0,
      radius: 5.5,
      char: '3',
      color: Colors.yellowAccent,
    );

    hexagonButton.paint(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
