import 'dart:async';
import 'dart:ui';

import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shootinggame/friends/DealerBord.dart';
import 'package:shootinggame/screens/game_screens/CharacterScreen.dart';
import 'package:shootinggame/screens/game_screens/MainScreen.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../BaseWidget.dart';
import 'PlayGround.dart';
import 'ScreenState.dart';

ScreenManager screenManager = ScreenManager();

class ScreenManager extends Game with TapDetector {
  Function _fn;
  ScreenState _screenState;

  // Screens

  PlayGround _playScreen;
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
    _characterScreen?.resize();
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

  void startNewGame(int char) {
    _playScreen = PlayGround(char);
    _playScreen.resize();

    _screenState = ScreenState.kPlayScreen;
  }

  void setSpeedfactor(double factor, bool useAsAbsolute) {
    if (useAsAbsolute) {
      _playScreen?.speedfactor = factor;
    } else {
      _playScreen?.speedfactor = _playScreen.speedfactor * factor;
    }
    print('new speedfactor: ${_playScreen.speedfactor}');
  }

  void showDeal(double x, double y, DealerBord dealerBord) {
    _playScreen?.openDeal(x, y);
  }

  void setTree(double power) {
    _playScreen?.setTree(power);
  }

  StoryHandler getStoryHandler() {
    return _playScreen.storyHandler;
  }

  Player getPlayer() {
    return _playScreen.player;
  }
}
