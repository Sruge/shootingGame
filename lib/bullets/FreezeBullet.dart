import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/FreezeEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

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
  void hitPlayer(Player player) {
    player.addEffect(FreezeEffect(player, null));
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    enemy.addEffect(FreezeEffect(null, enemy));
    die();
  }
}
