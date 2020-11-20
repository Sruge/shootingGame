import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/gestures/tap.dart';

import '../BaseWidget.dart';
import 'SizeHolder.dart';

class Background extends BaseWidget {
  SpriteComponent _bgSprite;

  Background(String src) {
    _bgSprite = SpriteComponent.fromSprite(750, 450, Sprite(src));
  }

  @override
  void render(Canvas canvas) {
    _bgSprite.render(canvas);
  }

  @override
  void resize() {
    _bgSprite.width = screenSize.width + 500;
    _bgSprite.height = screenSize.height;
  }

  @override
  void update(double t) {}

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    fn();
  }

  void setSpeed(List<double> speed) {}
}
