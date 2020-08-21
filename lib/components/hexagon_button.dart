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
  final Color backgroundColor;
  List<Offset> _offsets;

  HexagonButton({
    @required this.centralPoint,
    @required this.sideLength,
    @required this.strokeWidth,
    @required this.radius,
    @required this.char,
    @required this.color,
    @required this.textColor,
    @required this.backgroundColor,
  });

  void paint(Canvas canvas, Size size) {
    List<Offset> offsets = getOffsets();
    Map<int, Offset> offsetMap = offsets.asMap();

    Paint borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    TextPainter textPainter = _getTextPainter();
    Path borderPath = _getHexagonButtonBorderPath(offsetMap);
    Path backgroundPath = _getHexagonButtonBackgroundPath(offsetMap);

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    canvas.drawPath(backgroundPath, backgroundPaint);

    textPainter.paint(
      canvas,
      Offset(
        // TODO: update after font
        centralPoint.dx - textPainter.text.style.fontSize / 4,
        centralPoint.dy - 2 - textPainter.text.style.fontSize / 2,
      ),
    );

    canvas.drawPath(borderPath, borderPaint);
  }

  TextPainter _getTextPainter() {
    TextStyle textStyle = TextStyle(
      color: textColor,
      fontSize: 28,
      fontWeight: FontWeight.bold,
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

  // TODO: implement scale
  List<Offset> getOffsets() {
    var rootThree = Math.sqrt(3);
    if (_offsets == null) {
      List<Offset> points = List<Offset>();
      double sl = sideLength - (strokeWidth / 2);
      Offset defaultCentralPoint = Offset(sl * rootThree / 2, sl);
      double centralPointXDiff = centralPoint.dx - defaultCentralPoint.dx;
      double centralPointYDiff = centralPoint.dy - defaultCentralPoint.dy;

      DoubleUpdater xUpdater = (x) => (x) + centralPointXDiff;
      DoubleUpdater yUpdater = (y) => (y) + centralPointYDiff;

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
        });

      _offsets = points;
    }

    return _offsets;
  }

  List<Offset> _getCentralOffsets(Map<int, Offset> pointsMap) {
    List<Offset> centeralPoints = List<Offset>();

    pointsMap.forEach((index, value) {
      bool isLastPoint = index == pointsMap.length - 1;

      Offset nextItem = pointsMap[isLastPoint ? 0 : index + 1];

      double x = (value.dx + nextItem.dx) / 2;
      double y = (value.dy + nextItem.dy) / 2;

      centeralPoints.add(Offset(x, y));
    });
    return centeralPoints;
  }

  Path _getHexagonButtonBorderPath(Map<int, Offset> pointsMap) {
    // image: https://image.prntscr.com/image/lh7LI-xlSAmKzR_K87bzUw.png
    Path borderPath = Path();

    List<Offset> centeralPoints = _getCentralOffsets(pointsMap);

    Offset cp1 = centeralPoints[0];
    Offset point1 = pointsMap[0];

    pointsMap.forEach((index, value) {
      Offset cp = centeralPoints[index];

      if (index == 0) {
        borderPath.moveTo(cp1.dx, cp1.dy);
      } else {
        borderPath.conicTo(value.dx, value.dy, cp.dx, cp.dy, radius);
      }
      if (index == pointsMap.length - 1) {
        borderPath.conicTo(point1.dx, point1.dy, cp1.dx, cp1.dy, radius);
      }
    });

    return borderPath;
  }

  Path _getHexagonButtonBackgroundPath(Map<int, Offset> pointsMap) {
    Path backgroundPath = Path();
    Offset point1 = pointsMap[0];

    pointsMap.forEach((index, value) {
      if (index == 0) {
        backgroundPath.moveTo(point1.dx, point1.dy);
      } else {
        backgroundPath.lineTo(value.dx, value.dy);
      }
      if (index == pointsMap.length - 1) {
        backgroundPath.lineTo(point1.dx, point1.dy);
      }
    });

    return backgroundPath;
  }
}
