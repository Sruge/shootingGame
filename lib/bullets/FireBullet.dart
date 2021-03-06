import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/FireEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class FireBullet extends SpecialBullet {
  double width;
  double height;
  double _power;

  FireBullet(
      double x, double y, double bulletSpeedX, double bulletSpeedY, this._power)
      : super(x, y, 20, 20, bulletSpeedX, bulletSpeedY, 'fire.png', 32, 32) {
    width = 20;
    height = 20;
    this.damage = 40 * _power;
    this.lifetime = 2;
    this.speedfactor = _power * 4;
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void hitPlayer(Player player) {
    super.hitPlayer(player);
    Effect effect = FireEffect(player, null, _power);
    effect.resize(player.getPosition());
    player.effects.add(effect);
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    super.hitEnemy(enemy);

    Effect effect = FireEffect(null, enemy, _power);
    effect.resize(Offset(enemy.x, enemy.y));
    enemy.effects.add(effect);
    die();
  }
}
