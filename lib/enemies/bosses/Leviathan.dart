import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

class Leviathan extends Enemy {
  double _disappearTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;
  double _power;
  EnemyType type;

  double _specialAttackInterval;
  StoryHandler _storyHandler;
  Leviathan(this._power, this._storyHandler) : super() {
    type = EnemyType.Boss;

    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _disappearTimer = 0;
    _specialAttackTimer = 0;

    health = 1000;
    maxHealth = 1000;
    attackRange = 40;
    attackInterval = 2.5;
    _specialAttackInterval = 4;
    bulletTypes = [BulletType.Freeze];
    enemySpeedFactor = 0.14;
    bulletSpeedFactor = 2;
    dmgFctr = 1;
    bulletLifetimeFctr = 1;
    type = EnemyType.Boss;

    entity = WalkingEntity('leviathan', 96, 96,
        Size(baseAnimationWidth * 3, baseAnimationHeight * 3));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Three, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    int rand = random.nextInt(bulletTypes.length);
    List<double> coords = getAttackingCoordinates();

    return FreezeBullet(coords[0], coords[1], coords[2], coords[3], _power);
  }

  @override
  void update(double t, List<double> speed) {
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
      super.update(t, speed);
    }
  }

  int getScore() {
    return 3;
  }

  void die() {
    _storyHandler.levelUpdateble = true;
    super.die();
  }
}
