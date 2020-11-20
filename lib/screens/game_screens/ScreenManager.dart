import 'dart:async';
import 'dart:ui';

import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shootinggame/screens/game_screens/CharacterScreen.dart';
import 'package:shootinggame/screens/game_screens/MainScreen.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import '../BaseWidget.dart';
import 'PlayGround.dart';
import 'ScreenState.dart';

ScreenManager screenManager = ScreenManager();

class ScreenManager extends Game with TapDetector {
  Function _fn;
  ScreenState _screenState;

  // Screens

  BaseWidget _playScreen;
  BaseWidget _mainScreen;
  BaseWidget _characterScreen;

  ScreenManager() {
    _fn = _init;

    _screenState = ScreenState.kMenuScreen;
  }

  @override
  void resize(Size size) {
    screenSize = size;
    _playScreen?.resize();
    _mainScreen?.resize();
    _characterScreen.resize();
  }

  @override
  void render(Canvas canvas) {
    _getActiveScreen()?.render(canvas);
  }

  @override
  void update(double t) {
    _fn(t);
  }

  Future<void> _init(double t) async {
    _fn = _update;
    _playScreen = PlayGround();
    _mainScreen = MainScreen();
    _characterScreen = CharacterScreen();

    Util flameUtils = Util();
    await flameUtils.fullScreen();
    await flameUtils.setOrientation(DeviceOrientation.landscapeLeft);
  }

  void _update(double t) {
    _getActiveScreen()?.update(t);
  }

  void onTapDown(TapDownDetails details) {
    _getActiveScreen()?.onTapDown(details, () {});
  }

  BaseWidget _getActiveScreen() {
    switch (_screenState) {
      case ScreenState.kMenuScreen:
        return _mainScreen;
      case ScreenState.kPlayScreen:
        return _playScreen;
      case ScreenState.kCharacterScreen:
        return _characterScreen;
      default:
        return _mainScreen;
    }
  }

  void switchScreen(ScreenState state) {
    _screenState = state;
  }

  void startNewGame() {
    _playScreen = PlayGround();
    _playScreen?.resize();

    _screenState = ScreenState.kPlayScreen;
  }

  void setSpeedfactor(double factor) {
    _playScreen.speedfactor = factor;
  }
}
