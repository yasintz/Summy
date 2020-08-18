import 'package:flutter/material.dart';
import 'package:summy/screens/game/buttons.dart';
import 'package:summy/components/page_wrapper.dart';
import 'package:summy/constants/game_constants.dart';
import 'package:summy/utils/responsive.dart';

import 'cp.dart';

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
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: GAME_CONSTANTS.BUTTONS_VERTICAL_PADDING,
                      horizontal: GAME_CONSTANTS.BUTTONS_HORIZONTAL_PADDING,
                    ),
                    // child: Buttons(),
                    child: CustomP()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
