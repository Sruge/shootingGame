import 'package:flutter/gestures.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/FireRingEffect.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class FireRingBullet extends SpecialBullet {
  double damage;
  double width;
  double height;
  BulletType type;
  double _power;

  FireRingBullet(
      double x, double y, double bulletSpeedX, double bulletSpeedY, this._power)
      : super(x, y, 16, 16, bulletSpeedX, bulletSpeedY, 'healbullet.png', 64,
            64) {
    type = BulletType.Heal;
    width = 20;
    height = 20;
    damage = -100 * _power;
    lifetime = 3 * _power;
    speedfactor = 1.6 * _power;
  }

  @override
  void update(double t, List<double> speed) {
    super.update(t, speed);
  }

  @override
  void hitPlayer(Player player) {
    FireRingEffect effect = FireRingEffect(player, null);
    effect.resize(player.getPosition());
    player.effects.add(effect);
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    FireRingEffect effect = FireRingEffect(null, enemy);
    effect.resize(Offset(enemy.x, enemy.y));
    enemy.effects.add(effect);
    die();
  }
}
