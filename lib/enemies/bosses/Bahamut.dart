import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../bullets/Bullet.dart';

class Bahamut extends Enemy {
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;

  double _specialAttackInterval;
  Bahamut() : super() {
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _specialAttackTimer = 0;

    bulletTypes = [
      BulletType.Purple,
      BulletType.Fire,
      BulletType.Freeze,
      BulletType.Smoke
    ];
    health = 3000;
    maxHealth = 3000;
    attackRange = 200;
    attackInterval = 2;
    attackRange = 150;
    attackInterval = 4;
    _specialAttackInterval = 5;
    enemySpeedFactor = 0.15;
    bulletSpeedFactor = 1;
    dmgFctr = 1;
    bulletLifetimeFctr = 1;
    entity = WalkingEntity('bahamut.png', 96, 96,
        Size(baseAnimationWidth * 2, baseAnimationHeight * 2));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Three, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  @override
  void update(double t, List<double> speed, StoryHandler storyHandler) {
    _specialAttackTimer += t;
    if (_specialAttackTimer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackTimer = 0;
    }

    super.update(t, speed, storyHandler);
  }

  int getScore() {
    return 30;
  }
}
