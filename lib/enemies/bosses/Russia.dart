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

class Russia extends Enemy {
  double _disappearTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double bulletSpeedFactor;
  double _specialAttackTimer;
  double _power;
  double _specialAttackInterval;
  EnemyType type;
  StoryHandler _storyHandler;
  Russia(this._power, this._storyHandler) : super() {
    type = EnemyType.Boss;
    health = 200;
    maxHealth = 200;
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _disappearTimer = 0;
    _specialAttackTimer = 0;

    attackRange = 250;
    attackInterval = 6;
    enemySpeedFactor = 0.2;
    _specialAttackInterval = 4;
    bulletSpeedFactor = 1;
    dmgFctr = 1;
    bulletLifetimeFctr = 2;

    entity = WalkingEntity(
        'russia', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.One, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
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
    if (_disappearTimer > 11.5) {
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
