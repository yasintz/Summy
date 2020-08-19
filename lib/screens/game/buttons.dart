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
    RenderBox referenceBox = context.findRenderObject();

    return GestureDetector(
      child: CustomPaint(
        painter: ButtonsPainter(
          buttonSize: GAME_CONSTANTS.HEXAGON_BUTTON_SIZE,
          items: [
            ButtonItem("1", false),
            ButtonItem("2", false),
            ButtonItem("3", false),
            ButtonItem("4", false),
            ButtonItem("5", false),
            ButtonItem("6", false),
            ButtonItem("7", false),
            ButtonItem("8", false),
          ],
        ),
        size: Size.infinite,
      ),
      onPanUpdate: (DragUpdateDetails details) {
        Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);

        print(localPosition);
      },
      onTapDown: (TapDownDetails details) {
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
