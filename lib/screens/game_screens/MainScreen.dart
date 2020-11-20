import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';
import 'package:shootinggame/screens/util/Background.dart';

class MainScreen extends BaseWidget {
  Background _bg;
  Rect _newGame;
  MainScreen() {
    _bg = Background('playground.png');
    _newGame = Rect.fromLTWH(50, 50, 200, 100);
  }
  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (_newGame.contains(detail.globalPosition)) {
      screenManager.startNewGame();
    } else {
      _bg.onTapDown(detail, () {
        screenManager.switchScreen(ScreenState.kPlayScreen);
      });
    }
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    Paint paint = Paint();
    paint.color = Color(0x4400bb00);
    canvas.drawRect(_newGame, paint);
  }

  @override
  void resize() {
    _bg.resize();
  }

  @override
  void update(double t) {
    _bg.update(t);
  }
}
