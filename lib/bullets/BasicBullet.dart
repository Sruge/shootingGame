import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';

import 'Bullet.dart';
import 'BulletType.dart';

class BasicBullet extends Bullet {
  double damage;
  BulletType _type;
  BasicBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      this._type, double lifetimeFctr, double damageFctr, double bulletSpeed)
      : super(x, y, _bulletSpeedX, _bulletSpeedY) {
    if (_type == BulletType.One) {
      damage = damageFctr * 20;
      lifetime = lifetime * lifetimeFctr;
      speedfactor = bulletSpeed * 2;
    } else if (_type == BulletType.Two) {
      damage = 40 * damageFctr;
      lifetime = 1.1 * lifetime * lifetimeFctr;
      speedfactor = bulletSpeed * 11;

      bullet = SpriteComponent.square(9, 'redBullet.png');
    } else if (_type == BulletType.Three) {
      damage = 60 * damageFctr;
      lifetime = 1.2 * lifetime * lifetimeFctr;
      speedfactor = bulletSpeed * 12;
      bullet = SpriteComponent.square(9, 'greenBullet.png');
    }
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }
}
