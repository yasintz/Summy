var groupBy = function (xs, key, itemMappter) {
  return xs.reduce(function (rv, x) {
    (rv[x[key]] = rv[x[key]] || []).push(itemMappter ? itemMappter(x) : x);
    return rv;
  }, {});
};

function h(arr, cb, ignore = []) {
  arr.filter((i) => ignore.indexOf(i) === -1).forEach(cb);
}

function getResponse(sayilar = [], islemler = [], resultCorrect) {
  function fn(ignoreSayi = [], ignoreIslem = []) {
    const _sayi = (cb) => h(sayilar, cb, ignoreSayi);
    const _islem = (cb) => h(islemler, cb, ignoreIslem);
    const _all = (cb) => _sayi((s) => _islem((i) => cb(s, i)));

    return {
      herIkisi: (cb) => {
        _all((s, i) => {
          cb(s, i, fn([...ignoreSayi, s], [...ignoreIslem, i]));
        });
      },
      sayi: (cb) => {
        _sayi((s) => {
          cb(s, fn([...ignoreSayi, s], ignoreIslem));
        });
      },
      islem: (cb) => {
        _islem((i) => {
          cb(i, fn(ignoreSayi, [...ignoreIslem, i]));
        });
      },
    };
  }

  var response = [];

  function build(combination) {
    var result = eval(combination);
    var hasStr = response.find((item) => item.combination == combination);
    var hasResultInSayilar = sayilar.indexOf(result) > -1;
    var isResultCorrect = resultCorrect(result);
    if (
      Number.isInteger(result) &&
      result > 0 &&
      !hasStr &&
      !hasResultInSayilar &&
      isResultCorrect
    ) {
      response.push({ combination, result });
    }
  }

  fn().herIkisi((s1, i1, b1) => {
    b1.herIkisi((s2, i2, b2) => {
      build(`${s1}${i1}${s2}`);
      b2.herIkisi((s3, i3, b3) => {
        build(`${s1}${i1}${s2}${i2}${s3}`);
        b3.sayi((s4) => {
          build(`${s1}${i1}${s2}${i2}${s3}${i3}${s4}`);
        });
      });
    });
  });

  var groupedItems = groupBy(
    response,
    'result',
    ({ combination }) => combination
  );

  var arr = [];

  Object.keys(groupedItems).forEach((key) => {
    const value = groupedItems[key];
    arr.push({
      value: parseInt(key, 10),
      combinations: value,
    });
  });
  return arr;
}

var sayi = [1, 2, 3, 4, 5, 6, 7, 8, 9];

function getAll() {
  var response = {};
  h(sayi, (s1) => {
    h(
      sayi,
      (s2) => {
        h(
          sayi,
          (s3) => {
            h(
              sayi,
              (s4) => {
                const numbers = [s1, s2, s3, s4];
                numbers.sort();

                const key = numbers.join();

                if (response[key]) {
                  return;
                }

                const results = getResponse(
                  numbers,
                  ['+', '-', '*', '/'],
                  (r) => r > 20
                );

                if (Object.keys(results).length > 0) {
                  response[key] = {
                    numbers,
                    results,
                  };
                }
              },
              [s1, s2, s3]
            );
          },
          [s1, s2]
        );
      },
      [s1]
    );
  });

  return response;
}

function dartBuilder(str) {
  const variableName = 'COMBINATION_JSON_STRING';
  return `const String ${variableName} = '${str}';`;
}

function getAllAsync() {
  return new Promise((resolve) => {
    resolve(getAll());
  });
}

const fs = require('fs');
const path = require('path');

getAllAsync().then((response) => {
  var str = JSON.stringify(Object.values(response));

  fs.writeFileSync(
    path.join(process.cwd(), '__xyz__.json'),
    JSON.stringify(Object.values(response).slice(0, 2))
  );

  fs.writeFileSync(
    path.join(process.cwd(), 'lib/data', 'combination_json_string.dart'),
    dartBuilder(str)
  );
});
