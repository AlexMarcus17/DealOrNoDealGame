// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:ui';
import 'package:rive/rive.dart' as rive;
import 'package:animated_background/animated_background.dart';
import 'package:dealornodeal/sound/sound.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late BannerAd bannerAd;
  bool isloaded = false;
  var adUnit = "ca-app-pub-3940256099942544/2435281174";
  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
          onAdLoaded: (ad) {
            setState(() {
              isloaded = true;
            });
          },
        ),
        request: const AdRequest());
    bannerAd.load();
  }

  void loadForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show(
            (FormError? formError) {
              // Handle dismissal by reloading form
              loadForm();
            },
          );
        }
      },
      (FormError formError) {
        // Handle the error
      },
    );
  }

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
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          loadForm();
        }
      },
      (FormError error) {
        // Handle the error
      },
    );

    initBannerAd();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<SoundManager>(context, listen: false).setplayers();
    });
    super.initState();
  }

  void howtoplay() {
    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      context: context,
      pageBuilder: (ctx, _, __) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.83,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 22, 81, 153),
                        border: Border.all(width: 3, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "How to play",
                            style: TextStyle(
                              color: Colors.amber,
                              fontFamily: "Coaster",
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            "- There will be 20 cases with different amounts of money inside, from one dollar up to one million.\n- At the start of the game, the player selects a case at random.\n- The player’s aim is to sell that case back to The Banker for the most amount of money possible.\n- The game has 6 rounds. In each round, the player will open a certain number of cases. The amounts from the opened cases will go out of the game.\n- At the end of each round, the bank will call to make an offer.\n- If all the offers are refused, the player will receive the amount from the box chosen at the beginning of the game.",
                            style: TextStyle(
                                fontFamily: "Coaster",
                                fontSize: 13,
                                color: Colors.yellow),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ZoomTapAnimation(
                            onTap: () {
                              Provider.of<SoundManager>(context, listen: false)
                                  .playbutton();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 32,
                              width: 56,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  color: Colors.yellow),
                              child: const Center(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: "Coaster"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: Image.asset("assets/others/close.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void settings() {
    showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      context: context,
      pageBuilder: (ctx, _, __) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 270,
                    width: 200,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 134, 255),
                        border: Border.all(width: 3, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: StatefulBuilder(builder: (context, setState) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Settings",
                                style: TextStyle(
                                    fontFamily: "Coaster",
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              Column(
                                children: [
                                  ZoomTapAnimation(
                                    onTap: () {
                                      setState(() {
                                        Provider.of<SoundManager>(context,
                                                listen: false)
                                            .setmusic();
                                      });
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 130,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                          color: Colors.yellow),
                                      child: Center(
                                        child: Text(
                                          (Provider.of<SoundManager>(context)
                                                  .music)
                                              ? "music: On"
                                              : "music: Off",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "Coaster"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ZoomTapAnimation(
                                    onTap: () {
                                      setState(() {
                                        Provider.of<SoundManager>(context,
                                                listen: false)
                                            .setsound();
                                      });
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 130,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                          color: Colors.yellow),
                                      child: Center(
                                        child: Text(
                                          (Provider.of<SoundManager>(context)
                                                  .sound)
                                              ? "sound: On"
                                              : "sound: Off",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "Coaster"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ZoomTapAnimation(
                                    onTap: howtoplay,
                                    child: Container(
                                      height: 32,
                                      width: 130,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3)),
                                          color: Colors.yellow),
                                      child: const Center(
                                        child: Text(
                                          "how to play",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: "Coaster"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          height: 26,
                          width: 26,
                          child: Image.asset("assets/others/close.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                "assets/others/backg.jpg",
                fit: BoxFit.fill,
              ),
            ),
            const rive.RiveAnimation.asset(
              "assets/others/colors.riv",
              animations: ["colorChange"],
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: const SizedBox(),
              ),
            ),
            AnimatedBackground(
              vsync: this,
              behaviour: RandomParticleBehaviour(
                  options: const ParticleOptions(
                      minOpacity: 0.3,
                      maxOpacity: 0.7,
                      spawnMinSpeed: 30,
                      spawnMaxSpeed: 55,
                      baseColor: Color.fromARGB(255, 4, 30, 100))),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 16, top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 125,
                                height: 24,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 10, 94, 86),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 16, 129, 25))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 28, right: 8),
                                    child: FittedBox(
                                      child: Text(
                                        NumberFormat('#,###').format(GetIt.I
                                                .get<SharedPreferences>()
                                                .getInt("score") ??
                                            0),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Coaster",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: -10,
                                  bottom: -6,
                                  child: SizedBox(
                                    height: 37,
                                    width: 37,
                                    child:
                                        Image.asset("assets/others/dollar.png"),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: TextButton(
                                onPressed: settings,
                                child:
                                    Image.asset("assets/others/settings.png")),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset("assets/others/newlogo.png"),
                    ),
                    const Expanded(
                      flex: 5,
                      child: SizedBox(),
                    ),
                    ZoomTapAnimation(
                      onTap: () {
                        Provider.of<SoundManager>(context, listen: false)
                            .playbutton();
                        Navigator.of(context).pushReplacementNamed("/game");
                      },
                      child: Stack(
                        children: [
                          Material(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 45,
                                width: 120,
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: FittedBox(
                                    child: Center(
                                      child: AnimatedTextKit(
                                        pause: Duration.zero,
                                        animatedTexts: [
                                          ColorizeAnimatedText(
                                            'START',
                                            speed: const Duration(
                                                milliseconds: 600),
                                            textStyle: const TextStyle(
                                                fontSize: 24,
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
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 1,
                            width: double.infinity,
                          ),
                          isloaded
                              ? SizedBox(
                                  width: bannerAd.size.width.toDouble(),
                                  height: bannerAd.size.height.toDouble(),
                                  child: AdWidget(ad: bannerAd),
                                )
                              : const SizedBox(
                                  height: 1,
                                  width: double.infinity,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
