import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FireBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../bullets/Bullet.dart';

class Phoenix extends Enemy {
  double _disappearTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;

  double _specialAttackInterval;
  double _power;
  Phoenix(this._power) : super() {
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _disappearTimer = 0;
    _specialAttackTimer = 0;

    health = 800;
    maxHealth = 800;
    attackRange = 300;
    attackInterval = 2.5;
    bulletTypes = [BulletType.Fire];
    enemySpeedFactor = 0.2;
    _specialAttackInterval = 2;
    bulletSpeedFactor = 1 + (_power * 0.1);
    dmgFctr = 2;
    bulletLifetimeFctr = 2;

    entity = WalkingEntity('phoenix', 96, 96,
        Size(baseAnimationWidth * 2, baseAnimationHeight * 2));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Three, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    List<double> coords = getAttackingCoordinates();

    return FireBullet(coords[0], coords[1], coords[2], coords[3], _power);
  }

  @override
  void update(double t, List<double> speed) {
    _disappearTimer += t;
    _specialAttackTimer += t;
    if (_specialAttackTimer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackTimer = 0 + (random.nextDouble() * 4 - 2);
    }
    super.update(t, speed);
  }

  int getScore() {
    return 3;
  }
}
