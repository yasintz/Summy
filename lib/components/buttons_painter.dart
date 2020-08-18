import 'package:flutter/material.dart';
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

    PolygonPathDrawer octagon = PolygonPathDrawer(
      centralPoint: Offset(
        size.width / 2,
        size.height / 2,
      ),
      polygonSize: octagonSize,
      specs: PolygonPathSpecs(sides: 8, rotate: 0, borderRadiusAngle: 0),
    );

    return octagon.getPoints();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
