import 'dart:math' as Math;
import 'package:flutter/material.dart';

// reference: https://github.com/leonardocaldas/flutter-polygon-clipper/blob/master/lib/polygon_path_drawer.dart

class PolygonPathDrawer {
  final Path path;
  final double polygonSize;
  final PolygonPathSpecs specs;
  final Offset centralPoint;

  PolygonPathDrawer({
    @required this.polygonSize,
    @required this.specs,
    this.centralPoint,
  }) : path = Path();

  static double getPolygonRadius(double polygonSize, PolygonPathSpecs specs) {
    return (polygonSize - specs.borderRadiusAngle) / 2;
  }

  List<Offset> getPoints() {
    final List<Offset> points = new List<Offset>();

    final anglePerSide = 360 / specs.sides;

    final arcLength =
        (_radius * _angleToRadian(specs.borderRadiusAngle)) + (specs.sides * 2);

    for (var i = 0; i <= specs.sides; i++) {
      double currentAngle = anglePerSide * i;
      bool isFirst = i == 0;
      points.add(_getLinePoint(currentAngle, arcLength, isFirst));
    }

    return points;
  }

  Path draw() {
    final anglePerSide = 360 / specs.sides;

    final arcLength =
        (_radius * _angleToRadian(specs.borderRadiusAngle)) + (specs.sides * 2);

    Path path = Path();

    for (var i = 0; i <= specs.sides; i++) {
      double currentAngle = anglePerSide * i;
      bool isFirst = i == 0;

      if (specs.borderRadiusAngle > 0) {
        _drawLineAndArc(path, currentAngle, arcLength, isFirst);
      } else {
        _drawLine(path, currentAngle, isFirst);
      }
    }

    return path;
  }

  double get _radius {
    return getPolygonRadius(polygonSize, specs);
  }

  Offset _getLinePoint(
    double currentAngle,
    double arcLength,
    bool isFirst,
  ) {
    if (specs.borderRadiusAngle > 0) {
      double prevAngle = currentAngle - specs.halfBorderRadiusAngle;
      double nextAngle = currentAngle + specs.halfBorderRadiusAngle;

      Offset previous = _getOffset(prevAngle, _radius);
      Offset next = _getOffset(nextAngle, _radius);
      if (isFirst) {
        return next;
      } else {
        return previous;
      }
    } else {
      Offset current = _getOffset(currentAngle, _radius);

      return current;
    }
  }

  _drawLine(
    Path path,
    double currentAngle,
    bool isFirst,
  ) {
    Offset current = _getOffset(currentAngle, _radius);

    if (isFirst)
      path.moveTo(current.dx, current.dy);
    else
      path.lineTo(current.dx, current.dy);
  }

  _drawLineAndArc(
    Path path,
    double currentAngle,
    double arcLength,
    bool isFirst,
  ) {
    double prevAngle = currentAngle - specs.halfBorderRadiusAngle;
    double nextAngle = currentAngle + specs.halfBorderRadiusAngle;

    Offset previous = _getOffset(prevAngle, _radius);
    Offset next = _getOffset(nextAngle, _radius);

    if (isFirst) {
      path.moveTo(next.dx, next.dy);
    } else {
      path.lineTo(previous.dx, previous.dy);
      path.arcToPoint(next, radius: Radius.circular(arcLength));
    }
  }

  double _angleToRadian(double angle) {
    return angle * (Math.pi / 180);
  }

  Offset _getOffset(double angle, double radius) {
    final rotationAwareAngle = angle - 90 + specs.rotate;

    final radian = _angleToRadian(rotationAwareAngle);
    final _centralPoint = getCentralPoint();
    final x = Math.cos(radian) * radius + _centralPoint.dx;
    final y = Math.sin(radian) * radius + _centralPoint.dy;

    return Offset(x, y);
  }

  Offset getCentralPoint() {
    if (centralPoint == null) {
      double offsetValue = _radius + specs.halfBorderRadiusAngle;

      return Offset(offsetValue, offsetValue);
    }
    return centralPoint;
  }

  void setCentralPoint(Offset point) {}
}

class PolygonPathSpecs {
  final int sides;
  final double rotate;
  final double borderRadiusAngle;
  final double halfBorderRadiusAngle;

  PolygonPathSpecs({
    @required this.sides,
    @required this.rotate,
    @required this.borderRadiusAngle,
  }) : halfBorderRadiusAngle = borderRadiusAngle / 2;
}
