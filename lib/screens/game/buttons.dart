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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: ButtonsPainter(
          buttonSize: GAME_CONSTANTS.HEXAGON_BUTTON_SIZE,
        ),
        size: Size.infinite,
      ),
      onPanUpdate: (DragUpdateDetails details) {
        RenderBox referenceBox = context.findRenderObject();
        Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);

        print(localPosition);
      },
      onPanEnd: (DragEndDetails details) {
        print(used);
      },
    );
  }
}
