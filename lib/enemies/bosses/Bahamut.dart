import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../bullets/Bullet.dart';
import '../EnemyType.dart';

class Bahamut extends Enemy {
  EnemyType type;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;
  double _power;
  StoryHandler _storyHandler;

  double _specialAttackInterval;
  Bahamut(this._power, this._storyHandler) : super() {
    type = EnemyType.Boss;
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

    _specialAttackInterval = 9;
    enemySpeedFactor = 0.10;
    bulletSpeedFactor = .5 + _power;
    dmgFctr = 2 * _power;
    bulletLifetimeFctr = 1;
    entity = WalkingEntity('bahamut', 96, 96,
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
    int rand = random.nextInt(bulletTypes.length);
    List<double> coords = getAttackingCoordinates();

    return FreezeBullet(coords[0], coords[1], coords[2], coords[3], _power);
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

  void die() {
    _storyHandler.levelUpdateble = true;
    super.die();
  }
}
