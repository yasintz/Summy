import 'package:flutter/material.dart';
import 'package:summy/components/hexagon_button.dart';
import 'dart:math' as Math;

import 'package:summy/constants/game_constants.dart';

const int buttonCount = 8;

class ButtonItem {
  final String text;
  final bool isSelected;

  ButtonItem(this.text, this.isSelected);

  ButtonItem update(bool selected) => ButtonItem(text, selected);
}

class ButtonsPainter extends CustomPainter {
  final double buttonSize;
  final double strokeWidth = 4.0;
  final double radius = 5.5;
  final List<ButtonItem> items;

  ButtonsPainter({
    @required this.buttonSize,
    @required this.items,
  }) : assert(items.length == buttonCount);

  @override
  void paint(Canvas canvas, Size size) {
    List<Offset> points = this._getPoints(size);

    points
        .asMap()
        .map(
          (index, e) => MapEntry(
            index,
            HexagonButton(
              centralPoint: e,
              sideLength: buttonSize,
              strokeWidth: strokeWidth,
              radius: radius,
              char: items[index].text,
              color: items[index].isSelected
                  ? GAME_CONSTANTS.SELECTED_BUTTON_COLOR
                  : GAME_CONSTANTS.NON_SELECTED_BUTTON_COLOR,
              textColor: items[index].isSelected
                  ? GAME_CONSTANTS.SELECTED_BUTTON_COLOR
                  : GAME_CONSTANTS.TEXT_COLOR,
            ),
          ),
        )
        .forEach(
      (key, value) {
        value.paint(canvas, size);
      },
    );
  }

  List<Offset> _getPoints(Size size) {
    double octagonSize = size.width - ((buttonSize + strokeWidth) * 2);
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
