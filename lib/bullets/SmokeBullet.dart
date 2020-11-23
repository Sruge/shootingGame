import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/SmokeEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class SmokeBullet extends SpecialBullet {
  double damage;
  double width;
  double height;

  SmokeBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(x, y, 20, 20, _bulletSpeedX, _bulletSpeedY, 'smoke.png', 0) {
    damage = 5;
    width = 20;
    height = 20;
    lifetime = 5;
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void update(double t, List<double> speed) {
    width += t * 50;
    height += t * 50;
    specialBullet.width = width;
    specialBullet.height = height;
    super.update(t, speed);
  }

  @override
  void hitPlayer(Player player) {
    if (player.effects.isEmpty) player.effects.add(SmokeEffect(player, null));
  }

  @override
  void hitEnemy(Enemy enemy) {
    if (enemy.effects.isEmpty) enemy.effects.add(SmokeEffect(null, enemy));
  }
}
