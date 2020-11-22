import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/enemies/EffectType.dart';

import 'SpecialBullet.dart';

class FreezeBullet extends SpecialBullet {
  double damage;

  FreezeBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(x, y, 16, 16, _bulletSpeedX, _bulletSpeedY, 'freeze.png', 3) {
    damage = 5;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  EffectType getEffect() {
    return EffectType.Freeze;
  }
}
