import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'DealerBord.dart';
import 'Friend.dart';
import 'FriendType.dart';

class Dealer extends Friend {
  WalkingEntity entity;
  String aniPath;
  DealerBord _dealerBord;
  double _timer;
  double _lifetime;
  double _switchDirTime;
  double _direction;
  double _dyingtime;

  Dealer() : super() {
    attackRange = 130;
    attackInterval = 3;
    _timer = 0;
    health = 4;
    maxHealth = 4;
    _lifetime = 10;
    _switchDirTime = 3;
    _direction = 1;
    _dyingtime = 0.2;

    _dealerBord = DealerBord(true);
    enemySpeedFactor = 0.05;

    entity = WalkingEntity(
        'dealer.png', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
  }

  void update(double t, List<double> bgSpeed) {
    _timer += t;
    if (_timer > _switchDirTime) {
      _direction = -_direction;
      _switchDirTime += 3;
    }

    if (leftOrDown < 1) {
      enemySpeedX = enemySpeedFactor * _direction;
      enemySpeedY = 0;
    } else {
      enemySpeedY = enemySpeedFactor * _direction;
      enemySpeedX = 0;
    }
    if (enemySpeedX < 0) {
      flipRender = false;
    } else if (enemySpeedX > 0) {
      flipRender = true;
    }

    x = x +
        t * enemySpeedX * screenSize.width -
        t * bgSpeed[0] * screenSize.width;
    y = y +
        t * enemySpeedY * screenSize.width -
        t * bgSpeed[1] * screenSize.width;

    entity.update(t, [enemySpeedX, enemySpeedY]);
    if (_timer > _lifetime) {
      if (state == EntityState.Dying) {
        if (_timer > _lifetime + _dyingtime) die();
      } else {
        state = EntityState.Dying;
        enemySpeedFactor = 0.7;
      }
    }
  }

  @override
  EffectType getEffect() {
    return EffectType.Deal;
  }

  @override
  void trigger() {
    screenManager.showDeal(x, y, _dealerBord);
  }
}
