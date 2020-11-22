import 'package:flutter/gestures.dart';
import 'package:shootinggame/enemies/EffectType.dart';

import 'SpecialBullet.dart';

class FireBullet extends SpecialBullet {
  double damage;

  FireBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(x, y, 20, 20, _bulletSpeedX, _bulletSpeedY, 'fire.png', 3) {
    damage = 5;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  EffectType getEffect() {
    return EffectType.Fire;
  }
}
