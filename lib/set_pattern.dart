import 'package:flutter/material.dart';
import 'package:summy/buttons.dart';
import 'package:summy/constants.dart';
import 'package:summy/utils/responsive.dart';

class SetPattern extends StatefulWidget {
  @override
  _SetPatternState createState() => _SetPatternState();
}

class _SetPatternState extends State<SetPattern> {
  bool isConfirm = false;
  List<int> pattern;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: Responsive.width(100, context),
              height:
                  Responsive.height(CONSTANTS.PART_OF_UPSIDE_HEIGHT, context),
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
