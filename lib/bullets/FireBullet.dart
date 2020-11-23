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

  FireBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(x, y, 20, 20, _bulletSpeedX, _bulletSpeedY, 'fire.png', 3) {
    damage = 5;
    width = 20;
    height = 20;
    lifetime = 2;
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void hitPlayer(Player player) {
    player.addEffect(FireEffect(player, null));
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    enemy.addEffect(FireEffect(null, enemy));
    die();
  }
}
