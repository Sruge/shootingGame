import 'package:flutter/gestures.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/GoldenEffect.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/effects/Shield.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import 'SpecialBullet.dart';

class HealBullet extends SpecialBullet {
  double damage;
  double width;
  double height;
  BulletType type;

  HealBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      double lifetimeFctr, double damageFctr, double bulletSpeed)
      : super(x, y, 24, 24, _bulletSpeedX, _bulletSpeedY, 'healbullet.png', 64,
            64) {
    type = BulletType.Heal;
    width = 20;
    height = 20;
    damage = -100 * damageFctr;
    lifetime = 1 * lifetimeFctr;
    speedfactor = 0.5 * bulletSpeed;
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
    Effect effect = HealEffect(player, null);
    effect.resize(0, 0);
    player.effects.add(effect);
    die();
  }

  @override
  void hitEnemy(Enemy enemy) {
    HealEffect effect = HealEffect(null, enemy);
    effect.resize(x, y);
    enemy.effects.add(effect);
    die();
  }
}
