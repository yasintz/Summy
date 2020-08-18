import 'package:flutter/material.dart';
import 'dart:math' as Math;

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

    // Size centralPoint = Size();

    double sw = 8.0;
    double sl = 40.0;

    // Path path = getHexagonPath(sw, sl);

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = sw;

    Path path = Path();
    path.conicTo(
      10, 10, 25, 25,
      // size.width / 4,
      // 3 * size.height / 4,
      // size.width,
      // size.height,
      20,
    );
    canvas.drawPath(path, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Path getHexagonPath(double sw, double sl) {
  Path path = Path();
  double rootThree = Math.sqrt(3);

  double xUpdater = sw / 2;
  double yUpdater = sw / 2;

  path.moveTo(
    (sl / 4 * rootThree) + xUpdater,
    ((sl / 2) - (sl / 4)) + yUpdater,
  ); // 1a

  path.lineTo(
    (sl / 2 * rootThree) + xUpdater,
    0 + yUpdater,
  ); //2

  path.lineTo(
    ((sl * rootThree) - (sl / 4 * rootThree)) + xUpdater,
    ((sl / 2) - (sl / 4)) + yUpdater,
  ); // 2a

  path.lineTo(
    (sl * rootThree) + xUpdater,
    (sl / 2) + yUpdater,
  ); // 3

  path.lineTo(
    (sl * rootThree) + xUpdater,
    sl + yUpdater,
  ); // 3a

  path.lineTo(
    (sl * rootThree) + xUpdater,
    (3 * sl / 2) + yUpdater,
  ); // 4

  path.lineTo(
    ((sl * rootThree) - (sl / 4 * rootThree)) + xUpdater,
    ((3 * sl / 2) + (sl / 4)) + yUpdater,
  ); // 4a

  path.lineTo(
    (sl / 2 * rootThree) + xUpdater,
    (2 * sl) + yUpdater,
  ); // 5

  path.lineTo(
    (sl / 4 * rootThree) + xUpdater,
    ((3 * sl / 2) + (sl / 4)) + yUpdater,
  ); // 5a

  path.lineTo(
    0 + xUpdater,
    (3 * sl / 2) + yUpdater,
  ); // 6

  path.lineTo(
    0 + xUpdater,
    sl + yUpdater,
  ); // 6a

  path.lineTo(
    0 + xUpdater,
    (sl / 2) + yUpdater,
  ); // 1

  path.lineTo(
    (sl / 4 * rootThree) + xUpdater,
    ((sl / 2) - (sl / 4)) + yUpdater,
  ); // 1a

  return path;
}
