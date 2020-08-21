// To parse this JSON data, do
//
//     final combination = Combination.fromJson(jsonString);

import 'dart:convert';

class Combination {
  Combination({
    this.numbers,
    this.result,
  });

  List<int> numbers;
  Map<String, List<String>> result;

  static List<Combination> fromJson(String str) => List<Combination>.from(
        json.decode(str).map((x) => Combination._fromJson(x)),
      );

  factory Combination._fromJson(Map<String, dynamic> json) => Combination(
        numbers: List<int>.from(json["numbers"].map((x) => x)),
        result: Map.from(json["result"]).map(
          (k, v) => MapEntry<String, List<String>>(
            k,
            List<String>.from(
              v.map((x) => x),
            ),
          ),
        ),
      );
}
