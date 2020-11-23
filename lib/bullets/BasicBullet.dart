import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';

import 'Bullet.dart';
import 'BulletType.dart';

class BasicBullet extends Bullet {
  double damage;
  BulletType _type;
  BasicBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      this._type, lifetimeFctr, damageFctr)
      : super(x, y, _bulletSpeedX, _bulletSpeedY, 4) {
    if (_type == BulletType.One) {
      damage = damageFctr;
      lifetime = lifetime * lifetimeFctr;
    } else if (_type == BulletType.Two) {
      damage = 2 * damageFctr;
      lifetime = 2 * lifetime * lifetimeFctr;
      bullet = SpriteComponent.square(9, 'redBullet.png');
    }
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }
}
