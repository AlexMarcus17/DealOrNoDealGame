// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:dealornodeal/providers/gameprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourCase extends StatefulWidget {
  bool show;
  YourCase(this.show);

  @override
  State<YourCase> createState() => _YourCaseState();
}

class _YourCaseState extends State<YourCase>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void didUpdateWidget(covariant YourCase oldWidget) {
    if (widget.show) animationController.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return (widget.show)
        ? CircularRevealAnimation(
            animation: animation,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset("assets/others/case2.png"),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              Provider.of<GameProvider>(context)
                                  .getusercase
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Coaster',
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
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
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              Provider.of<GameProvider>(context)
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
                              gradient: LinearGradient(colors: [
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
                                    ..style = PaintingStyle.stroke
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
          )
        : const SizedBox(
            width: 100,
            height: 50,
          );
  }
}
