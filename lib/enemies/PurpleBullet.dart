import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/enemies/EffectType.dart';

import 'SpecialBullet.dart';

class PurpleBullet extends SpecialBullet {
  double damage;
  double _timer;

  PurpleBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(x, y, 32, 32, _bulletSpeedX, _bulletSpeedY, 'frozen.png', 2) {
    damage = 5;
    _timer = 0;
    lifetime = 2;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  EffectType getEffect() {
    return EffectType.Purple;
  }

  @override
  void update(double t, List<double> speed) {
    bulletSpeedX += t * bulletSpeedX;
    bulletSpeedY += t * bulletSpeedY;
    super.update(t, speed);
  }
}
