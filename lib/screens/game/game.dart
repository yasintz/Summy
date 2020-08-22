import 'package:flutter/material.dart';
import 'package:summy/components/circle_timer/circle_timer.dart';
import 'package:summy/components/circle_timer/timer_controller.dart';
import 'package:summy/components/page_wrapper.dart';
import 'package:summy/constants/game_constants.dart';
import 'package:summy/data/combination.dart';
import 'package:summy/screens/game/buttons.dart';
import 'package:summy/utils/calc_string.dart';
import 'package:summy/utils/responsive.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  CombinationResult combination = Combination.randomCombination();

  String realtimeResponse = "";
  List<String> selected = List();

  TimerController timerController = TimerController(
    animationDuration: Duration(seconds: 20),
    color: GameConstants.GREEN,
  );

  @override
  void initState() {
    super.initState();

    timerController.addEventListener(
      TimerControllerCallbackType.VALUE_CHANGE,
      () {
        if (timerController.value.inSeconds <= 3) {
          timerController.setColor(GameConstants.RED);
        } else {
          timerController.setColor(GameConstants.GREEN);
        }
      },
    );
    timerController.start();
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
                        "${combination.value}",
                        style: TextStyle(
                          fontSize: 56,
                          color: GameConstants.BROWN,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      size: 148,
                      stroke: 4,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      child: Text(
                        "${selected.join().length > 0 ? selected.join() : "?"} = ${realtimeResponse.length > 0 ? realtimeResponse : "?"}",
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
                onUpdate: (selected) {
                  double _realtimeResponse = calcString(selected);
                  setState(() {
                    if (_realtimeResponse != null) {
                      bool isInt = _realtimeResponse % 1 == 0;
                      realtimeResponse = isInt
                          ? _realtimeResponse.round().toString()
                          : _realtimeResponse.toStringAsFixed(1);
                    } else {
                      realtimeResponse = "";
                    }

                    this.selected = selected;
                  });
                },
                onStop: (used) {
                  var createdCombination = used.join("");
                  var isCorrectCombination =
                      combination.combinations.contains(createdCombination);

                  setState(() {
                    realtimeResponse = "";
                    this.selected = [];
                    if (isCorrectCombination) {
                      combination = Combination.randomCombination();
                      timerController.restart();
                    }
                  });
                },
                items: [
                  "+",
                  "${combination.numbers[0]}",
                  "-",
                  "${combination.numbers[1]}",
                  "*",
                  "${combination.numbers[2]}",
                  "/",
                  "${combination.numbers[3]}",
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
