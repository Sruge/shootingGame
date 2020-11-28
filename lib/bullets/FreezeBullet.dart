import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/FreezeEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class FreezeBullet extends SpecialBullet {
  double damage;
  double _power;

  FreezeBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      this._power)
      : super(
          x,
          y,
          16,
          16,
          _bulletSpeedX,
          _bulletSpeedY,
          'freeze.png',
          32,
          32,
        ) {
    damage = 40 * _power;
    lifetime = 2;
    speedfactor = _power * 5;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void hitPlayer(Player player) {
    Effect effect = FreezeEffect(player, null, _power);
    effect.resize(player.getPosition());
    player.effects.add(effect);
    super.hitPlayer(player);
  }

  @override
  void hitEnemy(Enemy enemy) {
    Effect effect = FreezeEffect(null, enemy, _power);
    effect.resize(Offset(enemy.x, enemy.y));
    enemy.effects.add(effect);
    super.hitEnemy(enemy);
  }
}
