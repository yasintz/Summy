import 'package:flutter/material.dart';
import 'package:summy/constants.dart';
import 'package:summy/utils/polygon_path_drawer/polygon_path_drawer.dart';

class Buttons extends StatefulWidget {
  final int dimension;
  final double relativePadding;
  final Color selectedColor;
  final Color notSelectedColor;
  final double pointRadius;
  final bool showInput;
  final int selectThreshold;
  final bool fillPoints;
  final Function(List<int>) onInputComplete;

  /// Creates [Buttons] with given params.
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
  const Buttons({
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
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  List<int> used = [];
  Offset currentPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: _ButtonPainter(
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
class _ButtonPainter extends CustomPainter {
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
  _ButtonPainter({
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
    List<Offset> points = this._getPoints(size);

    List<PolygonPathDrawer> hexagons = points
        .map((e) => PolygonPathDrawer(
              centralPoint: e,
              polygonSize: CONSTANTS.HEXAGON_BUTTON_SIZE,
              specs: PolygonPathSpecs(
                sides: 6,
                borderRadiusAngle: 8,
                rotate: 0,
              ),
            ))
        .toList();

    hexagons.forEach((element) {
      canvas.drawPath(element.draw(), Paint()..color = Colors.redAccent);
    });
  }

  List<Offset> _getPoints(Size size) {
    double octagonSize = size.width -
        CONSTANTS.HEXAGON_BUTTON_SIZE -
        CONSTANTS.BUTTONS_HORIZONTAL_PADDING * 2;

    PolygonPathDrawer octagon = PolygonPathDrawer(
      centralPoint: Offset(
        size.width / 2,
        size.height -
            octagonSize / 2 -
            CONSTANTS.HEXAGON_BUTTON_SIZE / 2 -
            CONSTANTS.BUTTONS_VERTICAL_PADDING,
      ),
      polygonSize: octagonSize,
      specs: PolygonPathSpecs(sides: 8, rotate: 0, borderRadiusAngle: 0),
    );

    return octagon.getPoints();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
