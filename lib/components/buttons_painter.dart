import 'package:flutter/material.dart';
import 'dart:math' as Math;
// import 'package:summy/constants/game_constants.dart';
import 'package:summy/utils/polygon_path_drawer/polygon_path_drawer.dart';

class ButtonsPainter extends CustomPainter {
  final double buttonSize;

  final PolygonPathSpecs hexagonSpecs = PolygonPathSpecs(
    sides: 6,
    borderRadiusAngle: 8,
    rotate: 0,
  );

  ButtonsPainter({@required this.buttonSize});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Paint()..color = Colors.purple,
    );

    List<Offset> points = this._getPoints(size);

    List<PolygonPathDrawer> hexagons = points
        .map((e) => PolygonPathDrawer(
              centralPoint: e,
              polygonSize: buttonSize,
              specs: hexagonSpecs,
            ))
        .toList();

    hexagons.forEach((element) {
      canvas.drawPath(element.draw(), Paint()..color = Colors.redAccent);
    });
  }

  List<Offset> _getPoints(Size size) {
    double buttonSizeByRadius =
        PolygonPathDrawer.getPolygonRadius(buttonSize, hexagonSpecs) * 2;

    double octagonSize = size.width - buttonSizeByRadius;
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

    final anglePerSide = 360 / 8;

    for (var i = 0; i <= 8; i++) {
      double currentAngle = anglePerSide * i;
      points.add(_getOffset(currentAngle));
    }

    return points;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
