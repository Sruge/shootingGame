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
      : super(x, y, _bulletSpeedX, _bulletSpeedY, damageFctr * 2) {
    if (_type == BulletType.One) {
      damage = damageFctr * 20;
      lifetime = lifetime * lifetimeFctr;
    } else if (_type == BulletType.Two) {
      damage = 40 * damageFctr;
      lifetime = 2 * lifetime * lifetimeFctr;
      bullet = SpriteComponent.square(9, 'redBullet.png');
    } else if (_type == BulletType.Three) {
      damage = 60 * damageFctr;
      lifetime = 3 * lifetime * lifetimeFctr;
      bullet = SpriteComponent.square(9, 'greenBullet.png');
    }
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }
}
