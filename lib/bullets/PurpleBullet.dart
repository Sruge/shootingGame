import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/PurpleEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class PurpleBullet extends SpecialBullet {
  double damage;
  double _timer;
  double _power;

  PurpleBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      this._power)
      : super(x, y, 32, 32, _bulletSpeedX, _bulletSpeedY, 'purpleBullets.png',
            32, 32) {
    damage = 30 * _power;
    _timer = 0;
    lifetime = 2 * _power;
    speedfactor = 5;
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
    // bulletSpeedX += t * bulletSpeedX;
    // bulletSpeedY += t * bulletSpeedY;
    super.update(t, speed);
  }

  @override
  void hitPlayer(Player player) {
    player.effects.add(PurpleEffect(player, null));
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    enemy.effects.add(PurpleEffect(null, enemy));
    die();
  }
}
