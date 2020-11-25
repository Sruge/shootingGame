import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/FreezeEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class FreezeBullet extends SpecialBullet {
  double damage;

  FreezeBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      double lifetimeFctr, double damageFctr, double bulletSpeed)
      : super(
          x,
          y,
          16,
          16,
          _bulletSpeedX,
          _bulletSpeedY,
          'freezeTrans.png',
          32,
          32,
        ) {
    damage = 50 * damageFctr;
    lifetime = 2;
    speedfactor = bulletSpeed * 2;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void hitPlayer(Player player) {
    Effect effect = FreezeEffect(player, null);
    effect.resize(x, y);
    player.effects.add(effect);
    super.hitPlayer(player);
  }

  @override
  void hitEnemy(Enemy enemy) {
    Effect effect = FreezeEffect(null, enemy);
    effect.resize(enemy.x, enemy.y);
    enemy.effects.add(effect);
    super.hitEnemy(enemy);
  }
}
