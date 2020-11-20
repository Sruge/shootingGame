import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/enemies/BulletType.dart';

class BasicBullet extends Bullet {
  double damage;
  BulletType _type;
  BasicBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      this._type)
      : super(x, y, _bulletSpeedX, _bulletSpeedY,
            SpriteComponent.square(7, 'bullet.png'), 4) {
    if (_type == BulletType.One)
      damage = 1;
    else if (_type == BulletType.Two) damage = 2;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }
}
