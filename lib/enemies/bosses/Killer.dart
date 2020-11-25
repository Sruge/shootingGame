import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../bullets/Bullet.dart';

class Killer extends Enemy {
  double _disappearTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;

  double _specialAttackInterval;
  Killer() : super() {
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _disappearTimer = 0;
    _specialAttackTimer = 0;

    health = 500;
    maxHealth = 500;
    attackRange = 200;
    attackInterval = 3;
    _specialAttackInterval = 3.2;
    bulletTypes = [BulletType.Freeze, BulletType.Fire];
    enemySpeedFactor = 0.22;
    bulletSpeedFactor = 1.5;

    entity = WalkingEntity(
        'killer.png', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
    random = Random();
  }

  @override
  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Two, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  @override
  void getHit(Bullet bullet) {
    health -= bullet.damage;
    if (health < 1) {
      state = EntityState.Dead;
    }
  }

  @override
  void update(double t, List<double> speed, StoryHandler storyHandler) {
    _disappearTimer += t;
    _specialAttackTimer += t;
    if (_specialAttackTimer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackTimer = 0;
    }
    if (_disappearTimer > 10) {
      Random random = Random();
      x = random.nextDouble() * screenSize.width;
      y = random.nextDouble() * screenSize.height;
      _disappearTimer = 0;
    } else {
      super.update(t, speed, storyHandler);
    }
  }

  int getScore() {
    return 3;
  }
}
