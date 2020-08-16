import 'package:flutter/material.dart';
import 'package:summy/components/buttons.dart';
import 'package:summy/components/page_wrapper.dart';
import 'package:summy/constants/game_constants.dart';
import 'package:summy/utils/responsive.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: Responsive.width(100, context),
              height: Responsive.height(
                GAME_CONSTANTS.PART_OF_UPSIDE_HEIGHT,
                context,
              ),
              color: Colors.yellowAccent,
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                child: Buttons(
                  selectedColor: Colors.amber,
                  dimension: 3,
                  pointRadius: 10,
                  onInputComplete: (List<int> input) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
