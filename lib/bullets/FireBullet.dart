import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/FireEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class FireBullet extends SpecialBullet {
  double damage;
  double width;
  double height;

  FireBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      double lifetimeFctr, double damageFctr, double bulletSpeed)
      : super(x, y, 20, 20, _bulletSpeedX, _bulletSpeedY, 'fire.png', 32, 32) {
    width = 20;
    height = 20;
    damage = 60 * damageFctr;
    lifetime = 2;
    speedfactor = bulletSpeed * 2;
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void hitPlayer(Player player) {
    super.hitPlayer(player);
    Effect effect = FireEffect(player, null);
    effect.resize(x, y);
    player.effects.add(effect);
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    super.hitEnemy(enemy);

    Effect effect = FireEffect(null, enemy);
    effect.resize(enemy.x, enemy.y);
    enemy.effects.add(effect);
    die();
  }
}
