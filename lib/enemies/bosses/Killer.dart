import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FireBullet.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/effects/EffectState.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../bullets/Bullet.dart';

class Killer extends Enemy {
  double _switchDirTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;
  double _power;
  double _switchDirTime;
  double _changeX, _changeY;
  bool switched;

  double _specialAttackInterval;
  Killer(this._power) : super() {
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _switchDirTimer = 0;
    _specialAttackTimer = 0;
    _changeX = _changeY = 1;

    health = 500;
    maxHealth = 500;
    attackRange = 400;
    attackInterval = 3;
    _specialAttackInterval = 3.2;
    bulletTypes = [BulletType.Freeze, BulletType.Fire];
    enemySpeedFactor = 0.22;
    bulletSpeedFactor = 1;
    bulletLifetimeFctr = 1.2;
    dmgFctr = 2;
    _switchDirTime = 8.5;
    switched = false;

    entity = WalkingEntity(
        'killer', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Two, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    int rand = random.nextInt(2);
    List<double> coords = getAttackingCoordinates();
    if (rand < 1)
      return FreezeBullet(coords[0], coords[1], coords[2], coords[3], _power);
    else
      return FireBullet(coords[0], coords[1], coords[2], coords[3], _power);
  }

  @override
  void update(double t, List<double> speed) {
    _switchDirTimer += t;
    _specialAttackTimer += t;
    if (_specialAttackTimer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackTimer = 0;
    }
    if (!frozen) {
      var distanceToCenter = getDistanceToCenter();
      if (_switchDirTimer > _switchDirTime) {
        _changeX = (random.nextDouble() * 2 - 1) / 10;
        _changeY = (random.nextDouble() * 2 - 1) / 10;
        _switchDirTimer = 0;
        switched = !switched;
      }
      if (switched) {
        enemySpeedX = _changeX;
        enemySpeedY = _changeY;
      } else {
        if (distanceToCenter > attackRange - 50) {
          double sumDistance;
          sumDistance = (x - screenSize.width / 2).abs() +
              (y - screenSize.height / 2).abs();
          enemySpeedX =
              -(x - screenSize.width / 2) / sumDistance * enemySpeedFactor;
          enemySpeedY =
              -(y - screenSize.height / 2) / sumDistance * enemySpeedFactor;
        } else {
          enemySpeedX = 0;
          enemySpeedY = 0;
        }
      }

      x = x +
          t * enemySpeedX * screenSize.width -
          t * speed[0] * screenSize.width;
      y = y +
          t * enemySpeedY * screenSize.width -
          t * speed[1] * screenSize.width;
    }

    enemyhealthBar.updateRect(maxHealth, health, x, y);
    effects.forEach((effect) {
      effect.update(t, x, y);
    });
    effects.removeWhere((element) => element.state == EffectState.Ended);
    entity.x = x;
    entity.y = y;
    entity.update(t, [enemySpeedX, enemySpeedY]);
    if (health <= 0) die();
  }

  int getScore() {
    return 3;
  }
}
