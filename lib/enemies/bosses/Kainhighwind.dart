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

class Kainhighwind extends Enemy {
  double _disappearTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackInterval;
  double _initialSpawnTime;
  double _spawnChangeInterval;
  double _disappearInterval;
  double _timer;
  StoryHandler _storyHandler;

  Kainhighwind() : super() {
    health = 40;
    maxHealth = 400;
    _timer = 0;

    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    attackRange = 200;
    attackInterval = 2;
    bulletTypes = [BulletType.Freeze];

    entity = WalkingEntity('kainhighwind.png', 32, 48,
        Size(baseAnimationWidth, baseAnimationHeight));
    attackRange = 150;
    attackInterval = 4;
    enemySpeedFactor = 0.03;
    _disappearInterval = 10;
    _spawnChangeInterval = 15;
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
  void update(double t, List<double> speed, StoryHandler storyHandler) {
    _storyHandler = storyHandler;
    storyHandler.levelUpdateble = false;
    _timer += t;
    if (_timer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackInterval = 2 * _timer;
    }
    if (_timer > _spawnChangeInterval) {
      if (_initialSpawnTime == null) {
        _initialSpawnTime = storyHandler.spawner.spawnInterval;
        storyHandler.spawner.spawnInterval = 1;
        storyHandler.spawner.nextSpawn -= 30;
        print(
            'Kainhighwind set Spawn Interval from $_initialSpawnTime to ${storyHandler.spawner.spawnInterval}');
        _spawnChangeInterval += 3;
      } else {
        _spawnChangeInterval += 40;
        print(
            'Kainhighwind set Spawn Interval from ${storyHandler.spawner.spawnInterval} back to $_initialSpawnTime');
        storyHandler.spawner.spawnInterval = _initialSpawnTime;
        _initialSpawnTime = null;
      }
    }
    if (_timer > _disappearInterval) {
      Random random = Random();
      x = random.nextDouble() * screenSize.width;
      y = random.nextDouble() * screenSize.height;
      _disappearInterval += 5;
    } else {
      super.update(t, speed, storyHandler);
    }
  }

  int getScore() {
    return 3;
  }

  void die() {
    if (_initialSpawnTime != null) {
      _storyHandler.spawner.spawnInterval = _initialSpawnTime;
    }
    _storyHandler.levelUpdateble = true;
    state = EntityState.Dead;
  }
}
