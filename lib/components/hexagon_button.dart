import 'package:flutter/material.dart';
import 'dart:math' as Math;

typedef DoubleUpdater = double Function(double x);

class HexagonButton {
  final Offset centralPoint;
  final double sideLength;
  final double strokeWidth;
  final double radius;
  final String char;
  final Color color;
  final Color textColor;

  HexagonButton({
    @required this.centralPoint,
    @required this.sideLength,
    @required this.strokeWidth,
    @required this.radius,
    @required this.char,
    @required this.color,
    @required this.textColor,
  });

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    TextPainter textPainter = _getTextPainter();
    Path path = _getHexagonButtonPath();

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.paint(
      canvas,
      Offset(
        // TODO: update after font
        centralPoint.dx - textPainter.text.style.fontSize / 4,
        centralPoint.dy - 2 - textPainter.text.style.fontSize / 2,
      ),
    );

    canvas.drawPath(path, paint);
  }

  TextPainter _getTextPainter() {
    TextStyle textStyle = TextStyle(
      color: textColor,
      fontSize: 32,
    );

    TextSpan textSpan = TextSpan(
      text: char,
      style: textStyle,
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    return textPainter;
  }

  Path _getHexagonButtonPath() {
    // image: https://image.prntscr.com/image/lh7LI-xlSAmKzR_K87bzUw.png
    Path path = Path();
    double rootThree = Math.sqrt(3);

    double sl = sideLength - (strokeWidth / 2);
    Offset defaultCentralPoint = Offset(sl * rootThree / 2, sl);
    double centralPointXDiff = centralPoint.dx - defaultCentralPoint.dx;
    double centralPointYDiff = centralPoint.dy - defaultCentralPoint.dy;

    DoubleUpdater xUpdater = (x) => (x) + centralPointXDiff;
    DoubleUpdater yUpdater = (y) => (y) + centralPointYDiff;

    List<Offset> points = List<Offset>();
    List<Offset> centeralPoints = List<Offset>();

    List<Offset> offsets = [
      Offset(0, sl / 2),
      Offset(sl * rootThree / 2, 0),
      Offset(sl * rootThree, sl / 2),
      Offset(sl * rootThree, 3 * sl / 2),
      Offset(sl * rootThree / 2, 2 * sl),
      Offset(0, 3 * sl / 2)
    ];

    offsets.asMap()
      ..forEach((key, value) {
        Offset currentValue = Offset(xUpdater(value.dx), yUpdater(value.dy));
        points.add(currentValue);
      })
      ..forEach((index, _) {
        Offset value = points[index];
        bool isLastPoint = index == points.length - 1;

        Offset nextItem = points[isLastPoint ? 0 : index + 1];

        double x = (value.dx + nextItem.dx) / 2;
        double y = (value.dy + nextItem.dy) / 2;

        centeralPoints.add(Offset(x, y));
      });

    Offset cp1 = centeralPoints[0];
    Offset point1 = points[0];

    path.moveTo(cp1.dx, cp1.dy); // 1a

    points.asMap().forEach((index, value) {
      Offset cp = centeralPoints[index];

      if (index != 0) {
        path.conicTo(value.dx, value.dy, cp.dx, cp.dy, radius);
      }
    });

    path.conicTo(point1.dx, point1.dy, cp1.dx, cp1.dy, radius);

    return path;
  }
}
