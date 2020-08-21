import 'package:flutter/material.dart';
import 'package:summy/components/circle_timer/circle_timer.dart';
import 'package:summy/components/circle_timer/timer_controller.dart';
import 'package:summy/components/page_wrapper.dart';
import 'package:summy/constants/game_constants.dart';
import 'package:summy/screens/game/buttons.dart';
import 'package:summy/utils/responsive.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  TimerController timerController = TimerController(
      animationDuration: Duration(seconds: 12), color: GameConstants.GREEN);

  @override
  void initState() {
    super.initState();

    String listenerId = "listener-for_set-red-color";

    timerController.addEventListener(
      TimerControllerCallbackType.VALUE_CHANGE,
      () {
        if (timerController.value.inSeconds <= 3) {
          timerController.setColor(Colors.red);

          timerController.removeEventListener(id: listenerId);
        }
      },
      id: listenerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: Responsive.width(100, context),
              color: GameConstants.YELLOW_PAPER,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 32),
                child: Column(
                  children: [
                    CircleTimer(
                      controller: timerController,
                      builder: (_) => Text(
                        "19",
                        style: TextStyle(),
                      ),
                      size: 148,
                      stroke: 4,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      child: Text(
                        "1+6x3=19",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: GameConstants.BROWN,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: Responsive.height(
              GameConstants.PART_OF_DOWNSIDE_HEIGHT,
              context,
            ),
            width: Responsive.width(100, context),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: GameConstants.BUTTONS_VERTICAL_PADDING,
                horizontal: GameConstants.BUTTONS_HORIZONTAL_PADDING,
              ),
              child: Buttons(
                onStop: (used) {
                  print(used);
                },
                items: [
                  "+",
                  "2",
                  "-",
                  "4",
                  "*",
                  "6",
                  "/",
                  "8",
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
