const additionSign = '+';
const subtractionSign = '-';
const multiplicationSign = '*';
const divisionSign = '/';

bool isSign(String text) {
  return text == additionSign ||
      text == subtractionSign ||
      text == multiplicationSign ||
      text == divisionSign;
}

double calc(String firstNum, String secondNum, String sign) {
  double _firstNum = double.parse(firstNum);
  double _secondNum = double.parse(secondNum);

  switch (sign) {
    case additionSign:
      return _firstNum + _secondNum;
    case subtractionSign:
      return _firstNum - _secondNum;
    case multiplicationSign:
      return _firstNum * _secondNum;

    case divisionSign:
    default:
      return _firstNum / _secondNum;
  }
}

bool handleSign(List<String> list, String sign) {
  int signIndex = list.indexOf(sign);
  bool hasSign = signIndex > -1;

  if (hasSign) {
    String prevNumber = list[signIndex - 1];
    String nextNumber = list[signIndex + 1];
    double response = calc(prevNumber, nextNumber, sign);

    list.insert(signIndex - 1, response.toString());
    list.removeAt(signIndex);
    list.removeAt(signIndex);
    list.removeAt(signIndex);
  }

  return hasSign;
}

double calcString(List<String> _list) {
  List<String> list = List.from(_list);
  var listMap = list.asMap();
  bool isCorrectForm = true;

  int zero = 0;

  listMap.forEach((key, value) {
    if (key % 2 == zero) {
      isCorrectForm = isCorrectForm && !isSign(value);
    } else {
      isCorrectForm = isCorrectForm && isSign(value);
    }
  });

  if (list.length % 2 == zero) {
    list.removeLast();
  }

  if (!isCorrectForm) {
    return null;
  }

  while (list.length > 1) {
    if (!handleSign(list, divisionSign)) {
      if (!handleSign(list, multiplicationSign)) {
        if (!handleSign(list, subtractionSign)) {
          if (!handleSign(list, additionSign)) {
//
          }
        }
      }
    }
  }

  return double.parse(list[0]);
}
