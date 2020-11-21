import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'dart:ui';

import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Button extends BaseWidget {
  PositionComponent _button;
  EffectType _type;
  double x, y;
  Button(this._type, this.x, this.y) {
    String imgUrl;
    switch (_type) {
      case EffectType.Fire:
        imgUrl = 'fire.png';
        break;
      case EffectType.Freeze:
        imgUrl = 'freeze.png';
        break;
      case EffectType.Purple:
        imgUrl = 'purpleBulletButton.png';
        break;
      default:
    }
    _button = SpriteComponent.fromSprite(48, 48, Sprite(imgUrl));
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void render(Canvas canvas) {
    _button.render(canvas);
  }

  @override
  void resize() {
    _button.resize(Size(screenSize.width * 0.05, screenSize.width * 0.05));
    _button.x = x;
    _button.y = y;
  }

  @override
  void update(double t) {
    _button.update(t);
    _button.x = x;
    _button.y = y;
  }
}
