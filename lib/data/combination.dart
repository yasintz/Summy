import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'combination_json_string.dart';

List<Combination> combinationFromJson(String str) =>
    List<Combination>.from(json.decode(str).map((x) {
      var numbers = List<int>.from(x["numbers"]);

      return Combination(
        numbers: numbers,
        results: List<CombinationResult>.from(
            x["results"].map((y) => CombinationResult(
                  value: y["value"],
                  combinations: List<String>.from(y["combinations"]),
                  numbers: numbers,
                ))),
      );
    }));

final List<Combination> _allCombinations =
    combinationFromJson(COMBINATION_JSON_STRING);

class Combination {
  Combination({
    @required this.numbers,
    @required this.results,
  });

  final List<int> numbers;
  final List<CombinationResult> results;

  static T _randomItem<T>(List<T> list) => list[Random().nextInt(list.length)];

  static CombinationResult randomCombination() =>
      _randomItem(_allCombinations)._randomResult();

  CombinationResult _randomResult() => _randomItem(results);
}

class CombinationResult {
  final int value;
  final List<String> combinations;
  final List<int> numbers;

  CombinationResult({
    @required this.value,
    @required this.combinations,
    @required this.numbers,
  });
}
