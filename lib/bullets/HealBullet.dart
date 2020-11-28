import 'package:flutter/gestures.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class HealBullet extends SpecialBullet {
  double damage;
  double width;
  double height;
  BulletType type;
  double _power;

  HealBullet(
      double x, double y, double bulletSpeedX, double bulletSpeedY, this._power)
      : super(x, y, 16, 16, bulletSpeedX, bulletSpeedY, 'greenbullet.png', 32,
            32) {
    type = BulletType.Heal;
    width = 20;
    height = 20;
    damage = -100 * _power;
    lifetime = 3 * _power;
    speedfactor = 1 * _power;
  }

  @override
  void update(double t, List<double> speed) {
    super.update(t, speed);
  }

  @override
  void hitPlayer(Player player) {
    Effect effect = HealEffect(player, null);
    effect.resize(player.getPosition());
    player.effects.add(effect);
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    HealEffect effect = HealEffect(null, enemy);
    effect.resize(Offset(enemy.x, enemy.y));
    enemy.effects.add(effect);
    die();
  }
}
