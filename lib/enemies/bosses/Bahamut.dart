import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import '../../bullets/Bullet.dart';

class Bahamut extends Enemy {
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;

  double _specialAttackInterval;
  Bahamut() : super() {
    health = 30;
    maxHealth = 30;
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    attackRange = 200;
    attackInterval = 2;
    bulletTypes = [BulletType.Purple, BulletType.Fire];

    entity = WalkingEntity('bahamut.png', 96, 96,
        Size(baseAnimationWidth * 2, baseAnimationHeight * 2));
    attackRange = 150;
    attackInterval = 4;
    enemySpeedFactor = 0.03;
    _specialAttackTimer = 0;
    _specialAttackInterval = 3;
    random = Random();
  }

  @override
  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.One, bulletLifetimeFctr, dmgFctr);
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
  void update(double t, List<double> speed) {
    _specialAttackTimer += t;
    if (_specialAttackTimer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackTimer = 0;
    }

    super.update(t, speed);
  }

  int getScore() {
    return 30;
  }
}
