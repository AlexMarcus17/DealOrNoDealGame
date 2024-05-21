// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';

class Ins extends StatefulWidget {
  String firsttext;
  String secondtext;
  bool singletext;
  Ins(this.firsttext, this.secondtext, {this.singletext = false});

  @override
  State<Ins> createState() => _InsState();
}

class _InsState extends State<Ins> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CircularRevealAnimation(
      animation: animation,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(0, 1, 5, 74),
          Color.fromARGB(200, 1, 5, 74),
          Color.fromARGB(255, 1, 5, 74),
          Color.fromARGB(200, 1, 5, 74),
          Color.fromARGB(0, 1, 5, 74)
        ])),
        child: Center(
          child: Stack(
            children: [
              Text(
                widget.singletext
                    ? widget.firsttext
                    : "${widget.firsttext}\n${widget.secondtext}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.singletext ? 28 : 18,
                  fontFamily: 'Coaster',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = const Color.fromARGB(204, 76, 71, 3),
                ),
              ),
              Text(
                widget.singletext
                    ? widget.firsttext
                    : "${widget.firsttext}\n${widget.secondtext}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: widget.singletext ? 28 : 18,
                    fontFamily: 'Coaster',
                    color: Colors.yellow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
