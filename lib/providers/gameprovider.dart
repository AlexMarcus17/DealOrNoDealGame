// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
  var round = 1;
  List<int> bankoffers = [];

  var _usercase = 0;
  var _openingcase = 0;
  var _openingsum = 0;
  var _orderedsums = [
    1,
    5,
    10,
    25,
    50,
    100,
    300,
    500,
    1000,
    2500,
    5000,
    7500,
    10000,
    25000,
    50000,
    75000,
    100000,
    250000,
    500000,
    1000000
  ];
  var _sums = [
    1,
    5,
    10,
    25,
    50,
    100,
    300,
    500,
    1000,
    2500,
    5000,
    7500,
    10000,
    25000,
    50000,
    75000,
    100000,
    250000,
    500000,
    1000000
  ]..shuffle();
  var _casesremaining = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];
  void opencase(int i) {
    _openingcase = i;
    _openingsum = _sums[i - 1];
    notifyListeners();
  }

  int get getopeningcase {
    return _openingcase;
  }

  int get getopeningsum {
    return _openingsum;
  }

  void removeopenedcase(int i) {
    _casesremaining.removeWhere((element) => element == i);
    int index = 0;
    for (int a = 0; a < _orderedsums.length; a++) {
      if (_orderedsums[a] == _sums[i - 1]) index = a;
    }
    _orderedsums[index] = 0;
    _sums[i - 1] = 0;
    notifyListeners();
  }

  int get usersum {
    return _sums[_usercase - 1];
  }

  List<int> get remainingcases {
    return _casesremaining;
  }

  List<int> get remainingsums {
    return _sums;
  }

  List<int> get orderedremainingsums {
    return _orderedsums;
  }

  int get remainingcasesnum {
    return _casesremaining.length;
  }

  void setusercase(int num) {
    _usercase = num;

    notifyListeners();
  }

  int get getusercase {
    return _usercase;
  }

  void newround() {
    round++;
    notifyListeners();
  }

  void generatebankoffer() {
    int offer = 3000;
    Random random = Random();
    int r = 0;
    if (round == 1) r = random.nextInt(8);
    if (round == 2) r = random.nextInt(3);
    int suma = 0;
    _sums.forEach((element) {
      suma += element;
    });

    switch (round) {
      case 1:
        suma = suma ~/ 7;
        offer = suma ~/ (8 + r);
        break;
      case 2:
        suma = suma ~/ 6.6;
        offer = suma ~/ (4 + r);
        break;
      case 3:
        suma = suma ~/ 4.2;
        offer = suma ~/ 3;
        break;
      case 4:
        suma = suma ~/ 3.5;
        offer = suma ~/ 2;
        break;
      case 5:
        suma = suma ~/ 2.8;
        offer = suma ~/ 1.5;
        break;
      case 6:
        suma = suma ~/ 2.14;
        offer = suma ~/ 1;
        break;
    }
    bankoffers.add(offer);
    notifyListeners();
  }

  void reset() {
    _orderedsums = [
      1,
      5,
      10,
      25,
      50,
      100,
      300,
      500,
      1000,
      2500,
      5000,
      7500,
      10000,
      25000,
      50000,
      75000,
      100000,
      250000,
      500000,
      1000000
    ];
    _sums = [
      1,
      5,
      10,
      25,
      50,
      100,
      300,
      500,
      1000,
      2500,
      5000,
      7500,
      10000,
      25000,
      50000,
      75000,
      100000,
      250000,
      500000,
      1000000
    ]..shuffle();
    _casesremaining = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20
    ];
    round = 1;
    bankoffers = [];
    _usercase = 0;
    _openingcase = 0;
    _openingsum = 0;
    notifyListeners();
  }
}
