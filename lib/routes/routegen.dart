import 'package:dealornodeal/screens/bankscreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dealornodeal/screens/gamescreen.dart';
import 'package:dealornodeal/screens/openscreen.dart';
import 'package:dealornodeal/screens/startscreen.dart';

import '../screens/finalscreen.dart';

class RouteGen {
  static Route<dynamic>? onGenRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: StartScreen(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 50),
        );

      case '/game':
        return PageTransition(
          child: GameScreen(),
          type: PageTransitionType.bottomToTop,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 500),
        );

      case '/open':
        var args = settings.arguments! as List<dynamic>;
        return PageTransition(
          child: OpenScreen(args[0] as bool, args[1] as Function?),
          type: PageTransitionType.fade,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
        );

      case '/bank':
        return PageTransition(
          child: BankScreen(),
          type: PageTransitionType.fade,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
        );

      case '/final':
        var args = (settings.arguments! as List<dynamic>);
        int firstsum = args[0];
        int secondsum = args[1];
        bool userbox = args[2];
        return PageTransition(
          child: FinalScreen(firstsum, secondsum, userbox),
          type: PageTransitionType.fade,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
        );

      default:
        return null;
    }
  }
}
