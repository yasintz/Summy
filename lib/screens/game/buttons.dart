import 'dart:async';

import 'package:flutter/material.dart';
import 'package:summy/screens/game/buttons_painter.dart';
import 'package:summy/constants/game_constants.dart';

typedef void OnStop(List<String> used);

class Buttons extends StatefulWidget {
  final List<String> items;
  final OnStop onStop;

  const Buttons({
    Key key,
    @required this.items,
    @required this.onStop,
  }) : super(key: key);

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool isInitialize = false;
  List<int> used = [];
  Offset currentPoint;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 150), () {
      setState(() {
        isInitialize = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox.shrink();
    if (isInitialize) {
      child = CustomPaint(
        painter: ButtonsPainter(
          currentPoint: currentPoint,
          buttonSize: GameConstants.HEXAGON_BUTTON_SIZE,
          items: widget.items,
          used: used,
        ),
        size: Size.infinite,
      );
    }

    return GestureDetector(
      child: AnimatedOpacity(
        opacity: isInitialize ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: child,
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
    if (used.length > 0) {
      widget.onStop(used.map((e) => widget.items[e]).toList());
    }

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
            GameConstants.HEXAGON_BUTTON_SIZE +
                GameConstants.BUTTON_STROKE_WIDTH;

        if (!used.contains(index) && isSelected) {
          used.add(index);
        }
      });
    });
  }
}
