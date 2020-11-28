import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/SmokeEffect.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'SpecialBullet.dart';

class SmokeBullet extends SpecialBullet {
  double damage;
  double width;
  double height;
  double rand;
  Random random;
  double _timer;
  double _x, _y;
  double _power;

  SmokeBullet(
      this._x, this._y, double bulletSpeedX, double bulletSpeedY, this._power)
      : super(
          _x,
          _y,
          20,
          20,
          bulletSpeedX,
          bulletSpeedY,
          'smoke.png',
          64,
          64,
        ) {
    width = 20;
    height = 20;
    damage = 0;
    lifetime = 5 * _power;
    speedfactor = 0;
    _timer = 0;
    random = Random();
    rand = (random.nextDouble() - 0.5) * 100;
  }

  void render(Canvas canvas) {
    canvas.save();
    specialBullet.render(canvas);
    canvas.restore();
  }

  void resize() {
    specialBullet.x = _x;
    specialBullet.y = _y;
  }

  @override
  void update(double t, List<double> speed) {
    _timer += t;
    specialBullet.update(t);
    width += t * 50;
    height += t * 50;
    specialBullet.width = width;
    specialBullet.height = height;
    specialBullet.x -= t * 25;
    specialBullet.y -= t * 25;
    specialBullet.x = specialBullet.x - t * speed[0] * screenSize.width;
    specialBullet.y = specialBullet.y - t * speed[1] * screenSize.width;
    if (_timer > lifetime) die();
  }

  @override
  void hitPlayer(Player player) {
    if (player.effects.isEmpty)
      player.effects.add(SmokeEffect(player, null, _power));
  }

  @override
  void hitEnemy(Enemy enemy) {
    if (enemy.effects.isEmpty)
      enemy.effects.add(SmokeEffect(null, enemy, _power));
  }
}
