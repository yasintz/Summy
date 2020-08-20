import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:summy/components/hexagon_button.dart';

import 'package:summy/constants/game_constants.dart';

const int buttonCount = 8;

// TODO: optimize
class ButtonsPainter extends CustomPainter {
  final double buttonSize;
  final List<String> items;
  final Offset currentPoint;
  final List<int> used;
  final Paint selectedPaint;

  ButtonsPainter({
    @required this.buttonSize,
    @required this.items,
    @required this.used,
    @required this.currentPoint,
  })  : assert(items.length == buttonCount),
        selectedPaint = Paint()
          ..color = GAME_CONSTANTS.SELECTED_BUTTON_COLOR
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = GAME_CONSTANTS.BUTTON_STROKE_WIDTH;

  @override
  void paint(Canvas canvas, Size size) {
    var centralPoints = getPoints(size);
    var pointsMap = centralPoints.asMap();
    var hexagonButtonMap = pointsMap.map(
      (index, e) {
        final isSelected = used.contains(index);
        return MapEntry(
          index,
          HexagonButton(
            centralPoint: e,
            sideLength: buttonSize,
            strokeWidth: GAME_CONSTANTS.BUTTON_STROKE_WIDTH,
            radius: GAME_CONSTANTS.BUTTON_RADIUS,
            char: items[index],
            color: isSelected
                ? GAME_CONSTANTS.SELECTED_BUTTON_COLOR
                : GAME_CONSTANTS.NON_SELECTED_BUTTON_COLOR,
            textColor: isSelected
                ? GAME_CONSTANTS.SELECTED_BUTTON_COLOR
                : GAME_CONSTANTS.TEXT_COLOR,
          ),
        );
      },
    );

    for (int i = 0; i < used.length - 1; ++i) {
      var p1 = centralPoints[used[i]];
      var p2 = centralPoints[used[i + 1]];

      var p1Offsets = hexagonButtonMap[used[i]].getOffsets();
      var p2Offsets = hexagonButtonMap[used[i + 1]].getOffsets();

      canvas.drawLine(
        getStartOffset(p1, p2, p1Offsets),
        getStartOffset(p2, p1, p2Offsets),
        selectedPaint,
      );
    }

    hexagonButtonMap.forEach(
      (key, value) {
        value.paint(canvas, size);
      },
    );

    if (used.isNotEmpty && currentPoint != null && used.length < buttonCount) {
      return;
      bool isOutsideOfAnyButton = true;

      Offset fixedCurrentPoint;

      if (currentPoint.dx < 0 || currentPoint.dy < 0) {}

      centralPoints.forEach(
        (e) {
          var distance = (fixedCurrentPoint - e).distance;

          isOutsideOfAnyButton = isOutsideOfAnyButton && distance > buttonSize;
        },
      );

      if (isOutsideOfAnyButton) {
        var lastItemIndex = used[used.length - 1];

        var p1 = getStartOffset(
          centralPoints[lastItemIndex],
          fixedCurrentPoint,
          hexagonButtonMap[lastItemIndex].getOffsets(),
        );

        canvas.drawLine(
          p1,
          fixedCurrentPoint,
          selectedPaint,
        );
      }
    }
  }

  Offset getStartOffset(Offset p1, Offset p2, List<Offset> points) {
    Offset defaultValue = calcOffset(
      p1,
      p2,
      GAME_CONSTANTS.HEXAGON_BUTTON_SIZE,
    );

    bool isEdge = false;
    double distance = 0;

    points.forEach(
      (e) {
        var _distance = (defaultValue - e).distance;
        var _isEdge = _distance < 10;
        isEdge = isEdge || _isEdge;
        if (_isEdge) {
          distance = _distance;
        }
      },
    );

    if (!isEdge) {
      return calcOffset(
          p1,
          p2,
          (GAME_CONSTANTS.HEXAGON_BUTTON_SIZE * GAME_CONSTANTS.ROOT_THREE / 2) +
              GAME_CONSTANTS.BUTTON_STROKE_WIDTH / 4);
    }

    return calcOffset(
      p1,
      p2,
      GAME_CONSTANTS.HEXAGON_BUTTON_SIZE - distance / 7,
    );
  }

  Offset calcOffset(Offset p1, Offset p2, double baseR) {
    double xLength = (p1.dx - p2.dx).abs();
    double yLength = (p1.dy - p2.dy).abs();
    double length = (p1 - p2).distance;

    double r = baseR - GAME_CONSTANTS.BUTTON_STROKE_WIDTH / 2;

    double x = r * xLength / length + (p1.dx < p2.dx ? p1.dx : -p1.dx);
    double y = r * yLength / length + (p1.dy < p2.dy ? p1.dy : -p1.dy);

    var offset = Offset(x.abs(), y.abs());

    return offset;
  }

  static List<Offset> getPoints(Size size) {
    double octagonSize = size.width -
        ((GAME_CONSTANTS.HEXAGON_BUTTON_SIZE +
                GAME_CONSTANTS.BUTTON_STROKE_WIDTH) *
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

    final anglePerSide = 360 / buttonCount;

    for (var i = 0; i < buttonCount; i++) {
      double currentAngle = anglePerSide * i;
      points.add(_getOffset(currentAngle));
    }

    return points;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
