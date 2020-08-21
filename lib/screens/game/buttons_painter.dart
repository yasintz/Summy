import 'package:flutter/material.dart';
import 'package:summy/cache.dart';
import 'dart:math' as Math;
import 'package:summy/components/hexagon_button.dart';

import 'package:summy/constants/game_constants.dart';
import 'package:summy/utils/line_segment.dart';

// TODO: optimize
class ButtonsPainter extends CustomPainter {
  final Offset currentPoint;
  final List<String> items;
  final List<int> used;

  final double buttonSize;
  final Paint selectedPaint;

  ButtonsPainter({
    @required this.buttonSize,
    @required this.items,
    @required this.used,
    @required this.currentPoint,
  })  : assert(items.length == GameConstants.BUTTON_COUNT),
        selectedPaint = Paint()
          ..color = GameConstants.PURPLE
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = GameConstants.BUTTON_STROKE_WIDTH;

  @override
  void paint(Canvas canvas, Size size) {
    var centralPoints =
        Cache.handleCache("${size.width}${size.height}", () => getPoints(size));

    var pointsMap = Cache.handleCache(
        "${centralPoints.hashCode}", () => centralPoints.asMap());

    var hexagonButtonMap = Cache.handleCache(
      "${pointsMap.hashCode}${used.toString()}",
      () => pointsMap.map(
        (index, e) {
          final isSelected = used.contains(index);
          return MapEntry(
            index,
            HexagonButton(
              centralPoint: e,
              sideLength: buttonSize,
              strokeWidth:
                  GameConstants.BUTTON_STROKE_WIDTH + (isSelected ? 1 : 0),
              radius: GameConstants.BUTTON_RADIUS,
              char: items[index],
              backgroundColor: Colors.white,
              color: isSelected ? GameConstants.PURPLE : GameConstants.GREY,
              textColor:
                  isSelected ? GameConstants.PURPLE : GameConstants.BROWN,
            ),
          );
        },
      ),
    );

    for (int i = 0; i < used.length - 1; ++i) {
      var p1 = centralPoints[used[i]];
      var p2 = centralPoints[used[i + 1]];

      canvas.drawLine(
        p1,
        p2,
        selectedPaint,
      );
    }

    if (used.isNotEmpty &&
        currentPoint != null &&
        used.length < GameConstants.BUTTON_COUNT) {
      var lastItemIndex = used[used.length - 1];
      var startPoint = centralPoints[lastItemIndex];

      var lineSegment = LineSegment(
        startPoint: startPoint,
        endPoint: currentPoint,
      );

      Offset fixedCurrentPoint = lineSegment.getPositivePoint();

      bool isOutsideOfLastButton =
          (fixedCurrentPoint - startPoint).distance > buttonSize;

      if (currentPoint.dx < 0 || currentPoint.dy < 0) {}

      if (isOutsideOfLastButton) {
        canvas.drawLine(
          startPoint,
          fixedCurrentPoint,
          selectedPaint,
        );
      }
    }

    hexagonButtonMap.forEach(
      (key, value) {
        value.paint(canvas, size);
      },
    );
  }

  static List<Offset> getPoints(Size size) {
    double octagonSize = size.width -
        ((GameConstants.HEXAGON_BUTTON_SIZE +
                GameConstants.BUTTON_STROKE_WIDTH) *
            2);
    Offset centralPoint = Offset(
      size.width / 2,
      size.height / 2,
    );

    Offset _getOffset(double angle) {
      double radius = octagonSize / 2;

      final radian = (angle - 90) * (Math.pi / 180);
      final x = Math.cos(radian) * radius + centralPoint.dx;
      final y = Math.sin(radian) * radius + centralPoint.dy;

      return Offset(x, y);
    }

    final List<Offset> points = new List<Offset>();

    final anglePerSide = 360 / GameConstants.BUTTON_COUNT;

    for (var i = 0; i < GameConstants.BUTTON_COUNT; i++) {
      double currentAngle = anglePerSide * i;
      points.add(_getOffset(currentAngle));
    }

    return points;
  }

  @override
  bool shouldRepaint(ButtonsPainter oldDelegate) {
    if (oldDelegate.currentPoint != this.currentPoint) {
      return true;
    }

    return false;
  }
}
