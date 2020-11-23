import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/GoldenEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class GoldenBullet extends SpecialBullet {
  double damage;
  double width;
  double height;

  GoldenBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(
            x, y, 20, 20, _bulletSpeedX, _bulletSpeedY, 'goldenBullet.png', 0) {
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
    super.update(t, speed);
  }

  @override
  void hitPlayer(Player player) {
    player.addEffect(GoldenEffect(player, null));
  }

  @override
  void hitEnemy(Enemy enemy) {
    enemy.addEffect(GoldenEffect(null, enemy));
  }
}
