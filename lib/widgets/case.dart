// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../sound/sound.dart';

class Case extends StatefulWidget {
  int index;
  bool boxchosen;
  Function(int) chosebox;
  bool isopening;
  Function(int) opencase;
  Case(
      this.index, this.boxchosen, this.chosebox, this.isopening, this.opencase);

  @override
  State<Case> createState() => _CaseState();
}

class _CaseState extends State<Case> {
  bool visible = true;
  void visoff() {
    Provider.of<SoundManager>(context, listen: false).playbutton();
    setState(() {
      if (!widget.isopening && !widget.boxchosen) {
        widget.chosebox(widget.index + 1);
        visible = false;
      }
      if (!widget.isopening && widget.boxchosen) {
        visible = false;
        widget.opencase(widget.index + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: ZoomTapAnimation(
        onTap: visible ? visoff : null,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  "assets/others/case2.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${widget.index + 1}',
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
                    '${widget.index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Coaster',
                    ),
                  ),
                ),
              ),
            ),
            // Positioned.fill(
            //   child: InkWell(
            //     onTap: visible ? visoff : null,
            //     child: SizedBox(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
