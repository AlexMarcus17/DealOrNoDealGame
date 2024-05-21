// ignore_for_file: use_key_in_widget_constructors

import 'package:dealornodeal/providers/gameprovider.dart';
import 'package:dealornodeal/routes/routegen.dart';
import 'package:dealornodeal/sound/sound.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await MobileAds.instance.initialize();
  await getshared();
  runApp(MyApp());
}

Future<void> getshared() async {
  var sp = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(sp);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameProvider>(
          create: (context) => GameProvider(),
        ),
        ChangeNotifierProvider<SoundManager>(
          create: (context) => SoundManager(
            true,
            true,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: RouteGen.onGenRoute,
      ),
    );
  }
}
