import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/GoldenEffect.dart';
import 'package:shootinggame/effects/Shield.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import 'SpecialBullet.dart';

class GoldenBullet extends SpecialBullet {
  double damage;
  double width;
  double height;

  GoldenBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY)
      : super(x, y, 20, 20, _bulletSpeedX, _bulletSpeedY, 'goldenBullet.png',
            32, 32, 5) {
    damage = 50;
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
    if (player.effects.isEmpty) {
      StoryHandler handler = screenManager.getStoryHandler();
      Shield effect = Shield(player, null, handler);
      //GoldenEffect effect = GoldenEffect(player, null);
      effect.resize(x, y);
      player.effects.add(effect);
    }
  }

  @override
  void hitEnemy(Enemy enemy) {
    if (enemy.effects.isEmpty) {
      StoryHandler handler = screenManager.getStoryHandler();
      Player player = screenManager.getPlayer();
      Shield effect = Shield(player, enemy, handler);
      effect.resize(x, y);
      enemy.effects.add(effect);
    }
  }
}
