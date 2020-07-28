import 'package:flutter/material.dart';
import 'package:summy/patter_lock.dart';

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
      appBar: AppBar(
        title: Text("Check Pattern"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: PatternLock(
              selectedColor: Colors.amber,
              dimension: 3,
              pointRadius: 10,
              onInputComplete: (List<int> input) {},
            ),
          ),
        ],
      ),
    );
  }
}
