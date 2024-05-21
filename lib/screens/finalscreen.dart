// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, curly_braces_in_flow_control_structures

import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:dealornodeal/widgets/ins.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../providers/gameprovider.dart';
import '../sound/sound.dart';

class FinalScreen extends StatefulWidget {
  int firstsum;
  int secondsum;
  bool userboxsum;
  FinalScreen(this.firstsum, this.secondsum, this.userboxsum);

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _scale = false;
  bool _value = false;
  bool _scale2 = false;
  bool _value2 = false;
  bool _buttonscale = false;
  bool chosed = false;
  bool watched = false;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

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
    _createRewardedAd();
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
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      setState(() {
        _scale2 = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 2700)).then((value) {
      setState(() {
        _value2 = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 4500)).then((value) {
      setState(() {
        _buttonscale = true;
      });
    });
    super.initState();
  }

  void _createRewardedAd() {
    var id = "ca-app-pub-3940256099942544/1712485313";
    if (_numRewardedLoadAttempts == 0)
      id = "ca-app-pub-3940256099942544/1712485313";
    if (_numRewardedLoadAttempts == 1)
      id = "ca-app-pub-3940256099942544/1712485313";
    if (_numRewardedLoadAttempts > 1)
      id = "ca-app-pub-3940256099942544/1712485313";
    RewardedAd.load(
        adUnitId: id,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 3) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
        child: Text("Ad not available"),
      )));
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
      },
    );

    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      setState(() {
        watched = true;
      });
      GetIt.I.get<SharedPreferences>().setInt(
          "score",
          ((GetIt.I.get<SharedPreferences>().getInt("score") ?? 0) +
              widget.firstsum));
      setState(() {
        widget.firstsum = widget.firstsum * 2;
      });
    });
    _rewardedAd = null;
    _createRewardedAd();
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
            AnimatedBackground(
              vsync: this,
              behaviour: RandomParticleBehaviour(
                  options: const ParticleOptions(
                      spawnMinSpeed: 30,
                      spawnMaxSpeed: 55,
                      baseColor: Color.fromARGB(255, 4, 30, 100))),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ins(
                      "YOU WON:",
                      "",
                      singletext: true,
                    ),
                    const SizedBox(
                      height: 12,
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
                                    !_value ? 0 : widget.firstsum,
                                    curve: Curves.easeIn,
                                    formatter: (value) {
                                      return NumberFormat.currency(symbol: "\$")
                                          .format(value);
                                    },
                                    duration:
                                        const Duration(milliseconds: 1100),
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
                                    !_value ? 0 : widget.firstsum,
                                    curve: Curves.easeIn,
                                    formatter: (value) {
                                      return NumberFormat.currency(symbol: "\$")
                                          .format(value);
                                    },
                                    duration:
                                        const Duration(milliseconds: 1100),
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
                      height: 12,
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
                                if (!watched) {
                                  _showRewardedAd();
                                }
                              },
                        child: watched
                            ? Container()
                            : Stack(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 65,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(255, 13, 228, 232),
                                              Color.fromARGB(255, 10, 105, 206),
                                            ])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FittedBox(
                                            child: Center(
                                              child: AnimatedTextKit(
                                                pause: Duration.zero,
                                                animatedTexts: [
                                                  ColorizeAnimatedText(
                                                    'Watch an ad and\ndouble your money',
                                                    textAlign: TextAlign.center,
                                                    speed: const Duration(
                                                        milliseconds: 600),
                                                    textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Coaster",
                                                    ),
                                                    colors: [
                                                      const Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      Colors.yellow
                                                    ],
                                                  ),
                                                ],
                                                isRepeatingAnimation: true,
                                                repeatForever: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    widget.userboxsum
                        ? Ins(
                            "Banker's",
                            "biggest offer",
                          )
                        : Ins(
                            "The amount from",
                            "your case",
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    AnimatedScale(
                      curve: Curves.elasticOut,
                      scale: _scale2 ? 1 : 0,
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
                                    !_value2 ? 0 : widget.secondsum,
                                    curve: Curves.easeIn,
                                    formatter: (value) {
                                      return NumberFormat.currency(symbol: "\$")
                                          .format(value);
                                    },
                                    duration:
                                        const Duration(milliseconds: 1100),
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
                                    !_value2 ? 0 : widget.secondsum,
                                    curve: Curves.easeIn,
                                    formatter: (value) {
                                      return NumberFormat.currency(symbol: "\$")
                                          .format(value);
                                    },
                                    duration:
                                        const Duration(milliseconds: 1100),
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
                                  _buttonscale = false;
                                });

                                Provider.of<GameProvider>(context,
                                        listen: false)
                                    .reset();
                                Future.delayed(
                                        const Duration(milliseconds: 1200))
                                    .then((value) {
                                  Navigator.of(context)
                                      .pushReplacementNamed("/");
                                });
                              },
                        child: Stack(
                          children: [
                            Material(
                              color: Colors.transparent,
                              elevation: 15,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 55,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      gradient: const LinearGradient(colors: [
                                        Color.fromARGB(255, 13, 228, 232),
                                        Color.fromARGB(255, 10, 105, 206),
                                      ])),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      child: Center(
                                        child: AnimatedTextKit(
                                          pause: Duration.zero,
                                          animatedTexts: [
                                            ColorizeAnimatedText(
                                              'Back to Home',
                                              speed: const Duration(
                                                  milliseconds: 600),
                                              textStyle: const TextStyle(
                                                  fontSize: 21,
                                                  fontFamily: "Coaster"),
                                              colors: [
                                                const Color.fromARGB(
                                                    255, 0, 0, 0),
                                                Colors.yellow
                                              ],
                                            ),
                                          ],
                                          isRepeatingAnimation: true,
                                          repeatForever: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: Container(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
