import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:summy/dr.dart';

Offset calcCirclePosition(
    int n, Size size, int dimension, double relativePadding) {
  final o = size.width > size.height
      ? Offset((size.width - size.height) / 2, 0)
      : Offset(0, (size.height - size.width) / 2);
  return o +
      Offset(
        size.shortestSide /
            (dimension - 1 + relativePadding * 2) *
            (n % dimension + relativePadding),
        size.shortestSide /
            (dimension - 1 + relativePadding * 2) *
            (n ~/ dimension + relativePadding),
      );
}

class PatternLock extends StatefulWidget {
  final int dimension;
  final double relativePadding;
  final Color selectedColor;
  final Color notSelectedColor;
  final double pointRadius;
  final bool showInput;
  final int selectThreshold;
  final bool fillPoints;
  final Function(List<int>) onInputComplete;

  /// Creates [PatternLock] with given params.
  ///
  /// [dimension] count of points horizontally and vertically.
  /// [relativePadding] padding of points area relative to distance between points.
  /// [selectedColor] color of selected points.
  /// [notSelectedColor] color of not selected points.
  /// [pointRadius] radius of points.
  /// [showInput] whether show user's input and highlight selected points.
  /// [selectThreshold] needed distance from input to point to select point.
  /// [fillPoints] whether fill points.
  /// [onInputComplete] callback that called when user's input complete. Called if user selected one or more points.
  const PatternLock({
    Key key,
    this.dimension = 3,
    this.relativePadding = 0.7,
    this.selectedColor, // Theme.of(context).primaryColor if null
    this.notSelectedColor,

    /// [Colors.black45] if null
    this.pointRadius = 10,
    this.showInput = true,
    this.selectThreshold = 25,
    this.fillPoints = false,
    @required this.onInputComplete,
  })  : assert(dimension != null),
        assert(relativePadding != null),
        assert(pointRadius != null),
        assert(showInput != null),
        assert(selectThreshold != null),
        assert(fillPoints != null),
        assert(onInputComplete != null),
        super(key: key);

  @override
  _PatternLockState createState() => _PatternLockState();
}

class _PatternLockState extends State<PatternLock> {
  List<int> used = [];
  Offset currentPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (DragEndDetails details) {
        if (used.isNotEmpty) {
          widget.onInputComplete(used);
        }
        setState(() {
          used = [];
          currentPoint = null;
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        RenderBox referenceBox = context.findRenderObject();
        Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);

        Offset circlePosition(int n) => calcCirclePosition(
              n,
              referenceBox.size,
              widget.dimension,
              widget.relativePadding,
            );

        setState(() {
          currentPoint = localPosition;
          for (int i = 0; i < widget.dimension * widget.dimension; ++i) {
            final toPoint = (circlePosition(i) - localPosition).distance;
            if (!used.contains(i) && toPoint < widget.selectThreshold) {
              used.add(i);
            }
          }
        });
      },
      child: CustomPaint(
        painter: _LockPainter(
          dimension: widget.dimension,
          used: used,
          currentPoint: currentPoint,
          relativePadding: widget.relativePadding,
          selectedColor: widget.selectedColor ?? Theme.of(context).primaryColor,
          notSelectedColor: widget.notSelectedColor ?? Colors.black45,
          pointRadius: widget.pointRadius,
          showInput: widget.showInput,
          fillPoints: widget.fillPoints,
        ),
        size: Size.infinite,
      ),
    );
  }
}

@immutable
class _LockPainter extends CustomPainter {
  final int dimension;
  final List<int> used;
  final Offset currentPoint;
  final double relativePadding;
  final Color selectedColor;
  final Color notSelectedColor;
  final double pointRadius;
  final bool showInput;
  final bool fillPoints;

  final Paint circlePaint;
  final Paint selectedPaint;
  _LockPainter({
    this.dimension,
    this.used,
    this.currentPoint,
    this.relativePadding,
    this.selectedColor,
    this.notSelectedColor,
    this.pointRadius,
    this.showInput,
    this.fillPoints,
  })  : circlePaint = Paint()
          ..color = notSelectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 2,
        selectedPaint = Paint()
          ..color = selectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.red;

    Path ex = PolygonPathDrawer(
      size: Size(45, 45),
      centralPoint: Offset(100, 100),
      specs: PolygonPathSpecs(sides: 6, rotate: 0, borderRadiusAngle: 10),
    ).draw();

    canvas.drawPath(ex, paint);
    return;

    Offset circlePosition(int n) =>
        calcCirclePosition(n, size, dimension, relativePadding);

    for (int i = 0; i < dimension; ++i) {
      for (int j = 0; j < dimension; ++j) {
        canvas.drawCircle(
          circlePosition(i * dimension + j),
          pointRadius,
          showInput && used.contains(i * dimension + j)
              ? selectedPaint
              : circlePaint,
        );
      }
    }

    if (showInput) {
      for (int i = 0; i < used.length - 1; ++i) {
        canvas.drawLine(
          circlePosition(used[i]),
          circlePosition(used[i + 1]),
          selectedPaint,
        );
      }

      if (used.isNotEmpty && currentPoint != null) {
        canvas.drawLine(
          circlePosition(used[used.length - 1]),
          currentPoint,
          selectedPaint,
        );
      }
    }
  }

  Path createHexagonPath({double size, Offset centralPoint}) {
    final path = Path();
    double angle = (Math.pi * 2) / 6;

    Offset firstPoint = Offset(size * Math.cos(0.0), size * Math.sin(0.0));

    path.moveTo(
      firstPoint.dx + centralPoint.dx,
      firstPoint.dy + centralPoint.dy,
    );

    for (int i = 1; i <= 6; i++) {
      double x = size * Math.cos(angle * i) + centralPoint.dx;
      double y = size * Math.sin(angle * i) + centralPoint.dy;
      path.lineTo(x, y);
      // path.arcToPoint(Offset(0, 0), radius: Radius.circular(1));
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
