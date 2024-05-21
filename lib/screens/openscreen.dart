// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, curly_braces_in_flow_control_structures

import 'dart:ui';

import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:dealornodeal/providers/gameprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../sound/sound.dart';

class OpenScreen extends StatefulWidget {
  bool justsee;
  Function? showad;
  OpenScreen(this.justsee, this.showad);
  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> with WidgetsBindingObserver {
  bool trans = false;
  bool _value = false;
  bool _fade = false;

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
    if (!widget.justsee) {
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        setState(() {
          trans = true;
        });
      });
      Future.delayed(const Duration(milliseconds: 1650)).then((value) {
        setState(() {
          _value = true;
        });
      });
      Future.delayed(const Duration(milliseconds: 2500)).then((value) {
        if (Provider.of<GameProvider>(context, listen: false).getopeningsum >
            2600)
          Provider.of<SoundManager>(context, listen: false).playbigcase();
        else
          Provider.of<SoundManager>(context, listen: false).playsmallcase();
      });

      Future.delayed(const Duration(milliseconds: 2700)).then((value) {
        setState(() {
          _fade = true;
        });
      });
      Future.delayed(const Duration(milliseconds: 5300)).then((value) {
        int i =
            Provider.of<GameProvider>(context, listen: false).remainingcasesnum;
        if (i == 16 || i == 12 || i == 9 || i == 6 || i == 4 || i == 3) {
          Provider.of<GameProvider>(context, listen: false).removeopenedcase(
              Provider.of<GameProvider>(context, listen: false).getopeningcase);
          Provider.of<GameProvider>(context, listen: false).generatebankoffer();

          Navigator.of(context).pushReplacementNamed("/bank");
        } else {
          Provider.of<GameProvider>(context, listen: false).removeopenedcase(
              Provider.of<GameProvider>(context, listen: false).getopeningcase);
          if (i == 15 || i == 10 || i == 5) {
            widget.showad!();
          }
          Navigator.of(context).pop();
        }
      });
    }

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
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (Provider.of<GameProvider>(context).getusercase == 0)
                              ? const SizedBox(
                                  width: 50,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
                                                "assets/others/case2.png"),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  Provider.of<GameProvider>(
                                                          context)
                                                      .getusercase
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Coaster',
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 4
                                                      ..color = Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  Provider.of<GameProvider>(
                                                          context)
                                                      .getusercase
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Coaster',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 28,
                                              width: 100,
                                              decoration: const BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                Color.fromARGB(255, 1, 5, 74),
                                                Color.fromARGB(0, 1, 5, 74)
                                              ])),
                                            ),
                                            Positioned(
                                              top: 2,
                                              bottom: 0,
                                              left: 6,
                                              child: Stack(
                                                children: [
                                                  Text(
                                                    'Your Case',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Coaster',
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 4
                                                        ..color = Colors.black,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Your Case",
                                                    style: TextStyle(
                                                        fontFamily: "Coaster",
                                                        fontSize: 18,
                                                        color: Colors.yellow),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          widget.justsee
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Image.asset(
                                              "assets/others/casechange2.png")),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                      width: 50,
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  width: 1,
                                ),
                        ],
                      ),
                    ),
                    const Flexible(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 7,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: GridView.count(
                          childAspectRatio: 3 +
                              (MediaQuery.of(context).size.width /
                                      MediaQuery.of(context).size.height) *
                                  7,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: List.generate(22, (index) {
                            if (index < 10) {
                              if (Provider.of<GameProvider>(context)
                                      .orderedremainingsums[index] ==
                                  0)
                                return Container();
                              else
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 1800),
                                  curve: Curves.bounceIn,
                                  opacity: ((Provider.of<GameProvider>(context)
                                                      .orderedremainingsums[
                                                  index] ==
                                              Provider.of<GameProvider>(context)
                                                  .getopeningsum) &&
                                          _fade)
                                      ? 0
                                      : 1,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/others/redbg.png"))),
                                      Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            NumberFormat('#,###').format(
                                                Provider.of<GameProvider>(
                                                            context)
                                                        .orderedremainingsums[
                                                    index]),
                                            style: TextStyle(
                                              fontSize: 12,
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
                                          child: Text(
                                            NumberFormat('#,###').format(
                                                Provider.of<GameProvider>(
                                                            context)
                                                        .orderedremainingsums[
                                                    index]),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Coaster',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }
                            if (index == 10 || index == 11) return Container();
                            if (index > 11) {
                              if (Provider.of<GameProvider>(context)
                                      .orderedremainingsums[index - 2] ==
                                  0)
                                return Container();
                              else
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 1800),
                                  curve: Curves.bounceIn,
                                  opacity: ((Provider.of<GameProvider>(context)
                                                      .orderedremainingsums[
                                                  index - 2] ==
                                              Provider.of<GameProvider>(context)
                                                  .getopeningsum) &&
                                          _fade)
                                      ? 0
                                      : 1,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/others/goldbg.png"))),
                                      Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            NumberFormat('#,###').format(
                                                Provider.of<GameProvider>(
                                                            context)
                                                        .orderedremainingsums[
                                                    index - 2]),
                                            style: TextStyle(
                                              fontSize: 12,
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
                                          child: Text(
                                            NumberFormat('#,###').format(
                                                Provider.of<GameProvider>(
                                                            context)
                                                        .orderedremainingsums[
                                                    index - 2]),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Coaster',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }

                            return Container();
                          }),
                        ),
                      ),
                    ),
                    widget.justsee
                        ? Flexible(
                            flex: 1,
                            child: Container(),
                          )
                        : Flexible(
                            flex: 1,
                            child: Center(
                              child: AnimatedSwitcher(
                                switchInCurve: Curves.elasticInOut,
                                switchOutCurve: Curves.elasticInOut,
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                duration: const Duration(milliseconds: 1000),
                                child: trans
                                    ? SizedBox(
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
                                                        : Provider.of<
                                                                    GameProvider>(
                                                                context)
                                                            .getopeningsum,
                                                    curve: Curves.easeIn,
                                                    formatter: (value) {
                                                      return NumberFormat
                                                              .currency(
                                                                  symbol: "\$")
                                                          .format(value);
                                                    },
                                                    duration: const Duration(
                                                        milliseconds: 1100),
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontFamily: 'Coaster',
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
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
                                                        : Provider.of<
                                                                    GameProvider>(
                                                                context)
                                                            .getopeningsum,
                                                    curve: Curves.easeIn,
                                                    formatter: (value) {
                                                      return NumberFormat
                                                              .currency(
                                                                  symbol: "\$")
                                                          .format(value);
                                                    },
                                                    duration: const Duration(
                                                        milliseconds: 1100),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontFamily: 'Coaster',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: Image.asset(
                                                "assets/others/case2.png"),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  Provider.of<GameProvider>(
                                                          context)
                                                      .getopeningcase
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Coaster',
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 4
                                                      ..color = Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  Provider.of<GameProvider>(
                                                          context)
                                                      .getopeningcase
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontFamily: 'Coaster',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                    // Flexible(
                    //   child: SizedBox(),
                    //   flex: 1,
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
