// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:dealornodeal/widgets/ins.dart';
import 'package:dealornodeal/widgets/yourcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../providers/gameprovider.dart';
import '../sound/sound.dart';
import '../widgets/case.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  String ins1 = "Choose your case";
  String ins2 = "You will keep it until the end";
  bool isopening = false;
  bool boxchosen = false;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
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
    initBannerAd();
    _createInterstitialAd();
    super.initState();
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      _createInterstitialAd();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    var id = "ca-app-pub-3940256099942544/4411468910";
    if (_numInterstitialLoadAttempts == 0)
      id = "ca-app-pub-3940256099942544/4411468910";
    if (_numInterstitialLoadAttempts == 1)
      id = "ca-app-pub-3940256099942544/4411468910";
    if (_numInterstitialLoadAttempts > 1)
      id = "ca-app-pub-3940256099942544/4411468910";
    InterstitialAd.load(
        adUnitId: id,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 3) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void opencase(int num) async {
    setState(() {
      isopening = true;
    });
    Provider.of<GameProvider>(context, listen: false).opencase(num);
    await Future.delayed(const Duration(milliseconds: 600));
    await Navigator.of(context)
        .pushNamed("/open", arguments: [false, _showInterstitialAd]);
    setState(() {
      isopening = false;
    });
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
                                fontSize: 15,
                                color: Colors.yellow),
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

  void showuserbox(int num) {
    setState(() {
      boxchosen = true;
      Provider.of<GameProvider>(context, listen: false).setusercase(num);
      Future.delayed(const Duration(milliseconds: 600)).then((value) {
        setState(() {
          isopening = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int round = Provider.of<GameProvider>(context).round;
    int casesnum = 0;
    int casesremaining = Provider.of<GameProvider>(context).remainingcasesnum;
    switch (round) {
      case 1:
        casesnum = -(15 - casesremaining);
        break;
      case 2:
        casesnum = -(11 - casesremaining);
        break;
      case 3:
        casesnum = -(8 - casesremaining);
        break;
      case 4:
        casesnum = -(5 - casesremaining);
        break;
      case 5:
        casesnum = -(3 - casesremaining);
        break;
      case 6:
        casesnum = -(2 - casesremaining);
        break;
    }
    ins1 = "Round $round";
    ins2 = "Open $casesnum more cases";
    if (!boxchosen) {
      ins1 = "Choose your case";
      ins2 = "You will keep it until the end";
    }

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
                      minOpacity: 0.3,
                      maxOpacity: 0.7,
                      spawnMinSpeed: 30,
                      spawnMaxSpeed: 55,
                      baseColor: Color.fromARGB(255, 47, 88, 201))),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          YourCase(boxchosen),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed("/open",
                                          arguments: [true, null]);
                                    },
                                    child:
                                        Image.asset("assets/others/eye.png")),
                              ),
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: TextButton(
                                    onPressed: settings,
                                    child: Image.asset(
                                        "assets/others/settings.png")),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Flexible(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 28,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: GridView.count(
                            childAspectRatio: 0.8 +
                                MediaQuery.of(context).size.width /
                                    MediaQuery.of(context).size.height,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 10,
                            crossAxisCount: 4,
                            children: List.generate(20, (index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 1200),
                                columnCount: 4,
                                child: ScaleAnimation(
                                    child: FadeInAnimation(
                                  child: Case(index, boxchosen, showuserbox,
                                      isopening, opencase),
                                )),
                              );
                            }),
                          ),
                        ),
                      ),
                      const Flexible(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Ins(ins1, ins2),
                      SizedBox(
                        height: 58,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 8,
                              width: double.infinity,
                            ),
                            isloaded
                                ? SizedBox(
                                    width: bannerAd.size.width.toDouble(),
                                    height: bannerAd.size.height.toDouble(),
                                    child: AdWidget(ad: bannerAd),
                                  )
                                : const SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
