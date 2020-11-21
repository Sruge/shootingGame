import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';
import 'package:shootinggame/screens/util/Background.dart';

class CharacterScreen extends BaseWidget {
  Background _bg;
  SpriteComponent _button;
  CharacterScreen() {
    _bg = Background('charScreenBg.png');
    _button = SpriteComponent.fromSprite(100, 50, Sprite('button.png'));
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (_button.toRect().contains(detail.globalPosition)) {
      screenManager.startNewGame(1);
    } else {
      _bg.onTapDown(detail, () {
        screenManager.switchScreen(ScreenState.kPlayScreen);
      });
    }
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    _button.render(canvas);
  }

  @override
  void resize() {
    _bg.resize();
    _button.resize(Size(100, 50));
  }

  @override
  void update(double t) {
    _bg.update(t);
    _button.update(t);
  }
}
