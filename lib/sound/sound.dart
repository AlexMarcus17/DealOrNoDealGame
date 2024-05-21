// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SoundManager with ChangeNotifier {
  final musicplayer = AudioPlayer();
  final buttonplayer = AudioPlayer();
  final bigcaseplayer = AudioPlayer();
  final smallcaseplayer = AudioPlayer();
  final phoneringplayer = AudioPlayer();
  late bool music;
  late bool sound;
  bool loaded = false;
  SoundManager(this.music, this.sound);
  Future<void> setplayers() async {
    if (!loaded) {
      loaded = true;
      await musicplayer.setAsset("assets/others/music.mp3");
      await buttonplayer.setAsset("assets/others/button.mp3");
      await bigcaseplayer.setAsset("assets/others/bigcase.mp3");
      await smallcaseplayer.setAsset("assets/others/smallcase.mp3");
      await phoneringplayer.setAsset("assets/others/phonering.mp3");
      await musicplayer.setVolume(0.2);
      await buttonplayer.setVolume(5);
      await bigcaseplayer.setVolume(2);
      await smallcaseplayer.setVolume(2);
      await phoneringplayer.setVolume(1);
      await musicplayer.setLoopMode(LoopMode.all);
      if (music) musicplayer.play();
    }
  }

  void pause() {
    musicplayer.pause();
  }

  void resume() {
    if (music) musicplayer.play();
  }

  Future<void> setmusic() async {
    music = !music;
    notifyListeners();
    if (music)
      musicplayer.play();
    else
      musicplayer.pause();
  }

  Future<void> setsound() async {
    sound = !sound;
    notifyListeners();
  }

  Future<void> playbutton() async {
    if (sound) {
      if (buttonplayer.position != Duration.zero)
        await buttonplayer.seek(Duration.zero);
      await buttonplayer.play();
    }
  }

  Future<void> playring() async {
    if (sound) {
      await phoneringplayer.seek(Duration.zero);
      await phoneringplayer.play();
    }
  }

  Future<void> playbigcase() async {
    if (sound) {
      await bigcaseplayer.seek(Duration.zero);
      await bigcaseplayer.play();
    }
  }

  Future<void> playsmallcase() async {
    if (sound) {
      await smallcaseplayer.seek(Duration.zero);
      await smallcaseplayer.play();
    }
  }
}
