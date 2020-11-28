import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/SmokeBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
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
  double _initialMaxEnemies;
  double _initialSpawnTime;
  double _spawnChangeInterval;
  double _disappearInterval;
  double _timer;
  StoryHandler _storyHandler;
  double bulletSpeedFactor;
  double _power;

  Kainhighwind(this._power, this._storyHandler) : super() {
    _timer = 0;
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;

    attackRange = 200;
    attackInterval = 2;
    bulletTypes = [BulletType.Smoke];
    bulletSpeedFactor = 1;
    health = 1000;
    maxHealth = 1000;
    attackRange = 200;
    attackInterval = 4;
    enemySpeedFactor = 0.18;
    dmgFctr = 0.5;
    bulletLifetimeFctr = 1;
    _disappearInterval = 10;
    _spawnChangeInterval = 5;
    _specialAttackInterval = 5;

    random = Random();
    entity = WalkingEntity(
        'kainhighwind', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Two, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    List<double> coords = getAttackingCoordinates();
    SmokeBullet bullet =
        SmokeBullet(coords[0], coords[1], coords[2], coords[3], _power);
    bullet.resize();
    return bullet;
  }

  @override
  void update(double t, List<double> speed) {
    _storyHandler.levelUpdateble = false;
    _timer += t;
    if (_timer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackInterval = 2 * _timer;
    }
    if (_timer > _spawnChangeInterval) {
      if (_initialSpawnTime == null) {
        _initialSpawnTime = _storyHandler.spawner.spawnInterval;
        _initialMaxEnemies = _storyHandler.spawner.maxEnemies;
        _storyHandler.spawner.spawnInterval = 0.8;
        _storyHandler.spawner.nextSpawn -= 1000;
        _storyHandler.spawner.maxEnemies = 20;
        print(
            'Kainhighwind set Spawn Interval from $_initialSpawnTime to ${_storyHandler.spawner.spawnInterval}');
        _spawnChangeInterval += 7;
      } else {
        _spawnChangeInterval += 45;
        print(
            'Kainhighwind set Spawn Interval from ${_storyHandler.spawner.spawnInterval} back to $_initialSpawnTime');
        _storyHandler.spawner.spawnInterval = _initialSpawnTime;
        _storyHandler.spawner.maxEnemies = _initialMaxEnemies;

        _initialSpawnTime = null;
      }
    }
    if (_timer > _disappearInterval) {
      Random random = Random();
      x = random.nextDouble() * screenSize.width;
      y = random.nextDouble() * screenSize.height;
      _disappearInterval += 15;
    } else {
      super.update(t, speed);
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
