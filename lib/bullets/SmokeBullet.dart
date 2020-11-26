import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/SmokeEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'SpecialBullet.dart';

class SmokeBullet extends SpecialBullet {
  double damage;
  double width;
  double height;
  double rand;
  Random random;

  SmokeBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      double lifetimeFctr, double damageFctr, double bulletSpeed)
      : super(
          x,
          y,
          20,
          20,
          _bulletSpeedX,
          _bulletSpeedY,
          'smoke.png',
          64,
          64,
        ) {
    width = 20;
    height = 20;
    damage = 0;
    lifetime = 5;
    speedfactor = 0;
    random = Random();
    rand = (random.nextDouble() - 0.5) * 100;
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  void render(Canvas canvas) {
    canvas.save();
    specialBullet.render(canvas);
    canvas.restore();
  }

  @override
  void update(double t, List<double> speed) {
    width += t * 50;
    height += t * 50;
    specialBullet.width = width;
    specialBullet.height = height;
    specialBullet.x -= t * 25 + t * 70 * rand;
    specialBullet.y -= t * 25 + t * 70 * rand;
    super.update(t, speed);
  }

  @override
  void hitPlayer(Player player) {
    if (player.effects.isEmpty) player.effects.add(SmokeEffect(player, null));
  }

  @override
  void hitEnemy(Enemy enemy) {
    if (enemy.effects.isEmpty) enemy.effects.add(SmokeEffect(null, enemy));
  }
}
