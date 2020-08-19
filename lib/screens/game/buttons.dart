import 'package:flutter/material.dart';
import 'package:summy/components/buttons_painter.dart';
import 'package:summy/constants/game_constants.dart';

class Buttons extends StatefulWidget {
  const Buttons({
    Key key,
  }) : super(key: key);

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
        painter: ButtonsPainter(
          currentPoint: currentPoint,
          buttonSize: GAME_CONSTANTS.HEXAGON_BUTTON_SIZE,
          items: [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
          ],
          used: used,
        ),
        size: Size.infinite,
      ),
      onPanUpdate: (DragUpdateDetails details) {
        handleUsed(details.globalPosition);
      },
      onTapDown: (TapDownDetails details) {
        handleUsed(details.globalPosition);
      },
      onPanEnd: onEnd,
      onTapUp: onEnd,
    );
  }

  void onEnd(_) {
    print(used);
    setState(() {
      currentPoint = null;
      used = [];
    });
  }

  void handleUsed(Offset globalPosition) {
    RenderBox referenceBox = context.findRenderObject();

    Offset localPosition = referenceBox.globalToLocal(globalPosition);

    var points = ButtonsPainter.getPoints(referenceBox.size);
    setState(() {
      currentPoint = localPosition;

      points.asMap().forEach((index, element) {
        final distance = (element - localPosition).distance;

        final isSelected = distance <
            GAME_CONSTANTS.HEXAGON_BUTTON_SIZE +
                GAME_CONSTANTS.BUTTON_STROKE_WIDTH;

        if (!used.contains(index) && isSelected) {
          used.add(index);
        }
      });
    });
  }
}
