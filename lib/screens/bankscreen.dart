// ignore_for_file: curly_braces_in_flow_control_structures, use_key_in_widget_constructors

import 'dart:ui';

import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:dealornodeal/widgets/ins.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../providers/gameprovider.dart';
import '../sound/sound.dart';

class BankScreen extends StatefulWidget {
  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> with WidgetsBindingObserver {
  bool chosed = false;
  bool _scale = false;
  bool _value = false;
  bool _buttonscale = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      Provider.of<SoundManager>(context, listen: false).pause();
    } else if (state == AppLifecycleState.resumed) {
      Provider.of<SoundManager>(context, listen: false).resume();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      Provider.of<SoundManager>(context, listen: false).playring();
    });
    Future.delayed(const Duration(milliseconds: 1200)).then((value) {
      setState(() {
        _scale = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 1900)).then((value) {
      setState(() {
        _value = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 3300)).then((value) {
      setState(() {
        _buttonscale = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: Image.asset(
              "assets/others/blue.jpg",
              fit: BoxFit.fill,
            )),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const SizedBox(),
              ),
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(top: 70, right: 16, left: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Lottie.asset("assets/others/phone1.json"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Ins("ROUND ${Provider.of<GameProvider>(context, listen: false).round}",
                      "Bank's Offer"),
                  const SizedBox(
                    height: 16,
                  ),
                  AnimatedScale(
                    curve: Curves.elasticOut,
                    scale: _scale ? 1 : 0,
                    duration: const Duration(milliseconds: 1200),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: AnimatedNumberText(
                                  !_value
                                      ? 0
                                      : Provider.of<GameProvider>(context,
                                              listen: false)
                                          .bankoffers[Provider.of<GameProvider>(
                                                  context,
                                                  listen: false)
                                              .round -
                                          1],
                                  curve: Curves.easeIn,
                                  formatter: (value) {
                                    return NumberFormat.currency(symbol: "\$")
                                        .format(value);
                                  },
                                  duration: const Duration(milliseconds: 1100),
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontFamily: 'Coaster',
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 4
                                      ..color = Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: AnimatedNumberText(
                                  !_value
                                      ? 0
                                      : Provider.of<GameProvider>(context,
                                              listen: false)
                                          .bankoffers[Provider.of<GameProvider>(
                                                  context,
                                                  listen: false)
                                              .round -
                                          1],
                                  curve: Curves.easeIn,
                                  formatter: (value) {
                                    return NumberFormat.currency(symbol: "\$")
                                        .format(value);
                                  },
                                  duration: const Duration(milliseconds: 1100),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontFamily: 'Coaster',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Ins("Do you accept", "the offer?"),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedScale(
                        curve: Curves.elasticOut,
                        scale: _buttonscale ? 1 : 0,
                        duration: const Duration(milliseconds: 1200),
                        child: ZoomTapAnimation(
                          onTap: chosed
                              ? null
                              : () {
                                  Provider.of<SoundManager>(context,
                                          listen: false)
                                      .playbutton();
                                  setState(() {
                                    chosed = true;
                                  });
                                  GetIt.I.get<SharedPreferences>().setInt(
                                      "score",
                                      ((GetIt.I
                                                  .get<SharedPreferences>()
                                                  .getInt("score") ??
                                              0) +
                                          Provider.of<GameProvider>(context,
                                                      listen: false)
                                                  .bankoffers[
                                              Provider.of<GameProvider>(context,
                                                          listen: false)
                                                      .round -
                                                  1]));

                                  setState(() {
                                    _buttonscale = false;
                                  });

                                  Future.delayed(
                                          const Duration(milliseconds: 1200))
                                      .then((value) {
                                    Navigator.of(context).pop();

                                    Navigator.of(context).pushReplacementNamed(
                                        "/final",
                                        arguments: [
                                          Provider.of<GameProvider>(context,
                                                      listen: false)
                                                  .bankoffers[
                                              Provider.of<GameProvider>(context,
                                                          listen: false)
                                                      .round -
                                                  1],
                                          Provider.of<GameProvider>(context,
                                                  listen: false)
                                              .usersum,
                                          false
                                        ]);
                                  });
                                },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 56,
                                  width: 115,
                                  child: Image.asset(
                                      "assets/others/dealbutton.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedScale(
                        curve: Curves.elasticOut,
                        scale: _buttonscale ? 1 : 0,
                        duration: const Duration(milliseconds: 1200),
                        child: ZoomTapAnimation(
                          onTap: chosed
                              ? null
                              : () {
                                  Provider.of<SoundManager>(context,
                                          listen: false)
                                      .playbutton();
                                  setState(() {
                                    chosed = true;
                                  });
                                  if (Provider.of<GameProvider>(context,
                                              listen: false)
                                          .round ==
                                      6)
                                    GetIt.I.get<SharedPreferences>().setInt(
                                        "score",
                                        ((GetIt.I
                                                    .get<SharedPreferences>()
                                                    .getInt("score") ??
                                                0) +
                                            Provider.of<GameProvider>(context,
                                                    listen: false)
                                                .usersum));
                                  setState(() {
                                    _buttonscale = false;
                                  });

                                  Future.delayed(
                                          const Duration(milliseconds: 1200))
                                      .then((value) {
                                    if (Provider.of<GameProvider>(context,
                                                listen: false)
                                            .round ==
                                        6) {
                                      Navigator.of(context).pop();
                                      int biggest = 0;
                                      Provider.of<GameProvider>(context,
                                              listen: false)
                                          .bankoffers
                                          .forEach((element) {
                                        if (element > biggest)
                                          biggest = element;
                                      });
                                      Navigator.of(context)
                                          .pushReplacementNamed("/final",
                                              arguments: [
                                            Provider.of<GameProvider>(context,
                                                    listen: false)
                                                .usersum,
                                            biggest,
                                            true
                                          ]);
                                    } else {
                                      Navigator.of(context).pop();
                                      Provider.of<GameProvider>(context,
                                              listen: false)
                                          .newround();
                                    }
                                  });
                                },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 60,
                                  width: 120,
                                  child: Image.asset(
                                      "assets/others/nodealbutton.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
