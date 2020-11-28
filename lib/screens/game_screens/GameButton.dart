import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'dart:ui';

import 'package:shootinggame/screens/BaseWidget.dart';

import 'ButtonType.dart';

class GameButton extends BaseWidget {
  PositionComponent _button;
  ButtonType _type;
  String _path;
  Rect _bgRect;
  double x, y, width, height;
  bool toggled;
  GameButton(this._type, this._path) {
    switch (_type) {
      case ButtonType.Normal:
        _button = SpriteComponent.fromSprite(0, 0, Sprite(_path));
        toggled = false;
        break;
      case ButtonType.Toggle:
        _button = SpriteComponent.fromSprite(0, 0, Sprite(_path));
        toggled = false;
        break;
      default:
    }
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    toggled = !toggled;
  }

  @override
  void render(Canvas canvas) {
    if (toggled) {
      Paint paint = Paint();
      paint.color = Color(0xffdca421);
      canvas.drawRect(_bgRect, paint);
    }
    _button.x = x;
    _button.y = y;
    _button.width = width;
    _button.height = height;
    canvas.save();
    _button.render(canvas);
    canvas.restore();
  }

  @override
  void resize() {
    _bgRect = Rect.fromLTWH(x, y, width, height);
  }

  @override
  void update(double t) {}

  Rect toRect() {
    return _button.toRect();
  }
}
