import 'package:flutter/material.dart';

class LineSegment {
  final Offset startPoint;
  final Offset endPoint;
  final Offset diff;

  LineSegment({
    @required this.startPoint,
    @required this.endPoint,
  }) : diff = startPoint - endPoint;

  Offset getOffsetByLength(double length) {
    double changer =
        (endPoint.dx < startPoint.dx || endPoint.dy < startPoint.dy) ? -1 : 1;

    double percent = lineLength / (length * changer);
    double x = xLineLength / percent;
    double y = yLineLength / percent;

    return Offset(x, y) + startPoint;
  }

  Offset getOffsetByAnyPoint({double x, double y}) {
    if (x == null) {
      return getOffsetByY(y);
    }

    return getOffsetByX(x);
  }

  Offset getPositivePoint({Offset origin}) {
    Offset _origin = origin == null ? Offset.zero : origin;

    if (endPoint > _origin) {
      return endPoint;
    }

    double startPointXYPercent = (startPoint.dx / startPoint.dy);
    double endPointXYPercent = (endPoint.dx / endPoint.dy);

    bool isXEqualToZero = endPointXYPercent > startPointXYPercent;

    if (isXEqualToZero) {
      return getOffsetByAnyPoint(x: _origin.dx);
    }

    return getOffsetByAnyPoint(y: _origin.dy);
  }

  Offset getOffsetByX(double x) {
    double newOffsetXLength = (startPoint.dx - x).abs();
    double newOffsetYLength = newOffsetXLength * yLineLength / xLineLength;
    double y = startPoint.dy + newOffsetYLength;

    if (x < startPoint.dx) {
      y = startPoint.dy - newOffsetYLength;
    }

    return Offset(x, y);
  }

  Offset getOffsetByY(double y) {
    double newOffsetYLength = (startPoint.dy - y).abs();
    double newOffsetXLength = newOffsetYLength * xLineLength / yLineLength;
    double x = startPoint.dx + newOffsetXLength;

    if (y < startPoint.dy) {
      x = startPoint.dx - newOffsetXLength;
    }

    return Offset(x, y);
  }

  double get slope {
    return diff.dy / diff.dx;
  }

  double get lineLength {
    return diff.distance;
  }

  double get xLineLength {
    return diff.dx;
  }

  double get yLineLength {
    return diff.dy;
  }

  double square(double n) {
    return n * n;
  }
}
