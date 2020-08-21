import 'package:flutter/material.dart';
import 'package:summy/components/circle_timer/timer_controller.dart';
import 'package:summy/constants/game_constants.dart';
import 'dart:math' as math;

class CircleTimer extends StatefulWidget {
  final TimerController controller;
  final WidgetBuilder builder;
  final double size;
  final double stroke;

  const CircleTimer({
    Key key,
    @required this.controller,
    @required this.builder,
    @required this.size,
    @required this.stroke,
  }) : super(key: key);

  @override
  _CircleTimerState createState() => _CircleTimerState();
}

class _CircleTimerState extends State<CircleTimer>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> animation;

  Color color;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: widget.controller.animationDuration,
    );

    animation = Tween(
      begin: 100.0,
      end: 0.0,
    ).animate(progressController);

    color = widget.controller.color;

    widget.controller.addEventListener(
      TimerControllerCallbackType.COLOR_CHANGE,
      () {
        setState(() {
          color = widget.controller.color;
        });
      },
    );

    animation.addListener(() {
      widget.controller.setValueFromAnimation(animation.value);
    });

    widget.controller.addEventListener(
      TimerControllerCallbackType.VALUE_CHANGE_IN_ANIMATION,
      () {
        progressController.forward();
      },
    );

    widget.controller.addEventListener(TimerControllerCallbackType.START, () {
      progressController.forward();
    });

    widget.controller.addEventListener(TimerControllerCallbackType.PAUSE, () {
      progressController.stop();
    });

    widget.controller.addEventListener(TimerControllerCallbackType.RESUME, () {
      progressController.forward();
    });

    widget.controller.addEventListener(TimerControllerCallbackType.STOP, () {
      progressController.reset();
    });
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (ctx, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            foregroundPainter: _CircleTimerPainter(
              currentProgress: animation.value,
              strokeWidth: widget.stroke,
              color: color,
            ),
            child: Center(
              child: widget.builder(ctx),
            ),
          ),
        );
      },
    );
  }
}

class _CircleTimerPainter extends CustomPainter {
  final double currentProgress;
  final double strokeWidth;
  final Color color;

  _CircleTimerPainter({
    @required this.currentProgress,
    @required this.strokeWidth,
    @required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = strokeWidth
      ..color = GameConstants.GREY
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width, size.height) / 2;
    double radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      outerCircle,
    );

    double angle = 2 * math.pi * (currentProgress / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      angle,
      false,
      completeArc,
    );
  }

  @override
  bool shouldRepaint(_CircleTimerPainter oldDelegate) {
    return oldDelegate.currentProgress != this.currentProgress;
  }
}
