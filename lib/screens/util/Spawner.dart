import 'dart:math';

import 'package:shootinggame/enemies/BasicEnemy.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/friends/Dealer.dart';
import 'package:shootinggame/friends/Friend.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import 'Level.dart';

class Spawner {
  double _spawnInterval;
  double _bossSpawnInterval;
  double _friendSpawnInterval;
  double _presentSpawnInterval;
  double _maxEnemies = 6;
  double _nextSpawn;
  double _nextBossSpawn;
  double _nextFriendSpawn;
  double _nextPresentSpawn;
  double _dmgMultiplier;
  double _attackRange;
  double _bulletLifetime;
  double _attackInterval;
  double _healthMulti;
  double _enemySpeed;
  List<EnemyType> _enemyTypes;
  List<PresentType> _presentTypes;
  Random _random;
  double _timer;
  List<Enemy> bosses;
  StoryHandler _storyHandler;
  Spawner(Level level, StoryHandler storyHandler) {
    _storyHandler = storyHandler;
    _timer = 0;
    _random = Random();
    _spawnInterval = level.spawnInterval;
    _bossSpawnInterval = level.bossSpawnInterval;
    _friendSpawnInterval = level.friendSpawnInterval;
    _presentSpawnInterval = level.presentSpawnInterval;
    _enemyTypes = level.enemyTypes;
    _maxEnemies = level.maxEnemies;
    _nextSpawn = 0;
    _nextBossSpawn = 20;
    _nextFriendSpawn = _friendSpawnInterval;
    _nextPresentSpawn = _presentSpawnInterval;
    bosses = level.bosses;
    _presentTypes = level.presentTypes;
    _attackInterval = level.attackIntervalMultiplier;
    _attackRange = level.attackRangeMultiplier;
    _dmgMultiplier = level.dmgMultiplier;
    _bulletLifetime = level.bulletLifetimeMultiplier;
    _healthMulti = level.healtMulti;
    _enemySpeed = level.enemySpeedMultiplier;
  }

  update(double t) {
    _timer += t;
    if (_timer > _nextSpawn) {
      BasicEnemy enemy = BasicEnemy(
          _enemyTypes[_random.nextInt(_enemyTypes.length)],
          _dmgMultiplier,
          _attackRange,
          _attackInterval,
          _bulletLifetime,
          _healthMulti,
          _enemySpeed);
      enemy.resize();
      _storyHandler.enemies.add(enemy);
      _nextSpawn = _timer + _spawnInterval;
    }
    if (_timer > _nextBossSpawn && bosses.isNotEmpty) {
      _storyHandler.enemies.add(bosses.first);
      bosses.removeAt(0);
      _nextBossSpawn = _timer + _bossSpawnInterval;
    }
    if (_timer > _nextFriendSpawn) {
      Friend friend = Dealer();
      friend.resize();
      _storyHandler.friends.add(friend);
      _nextFriendSpawn = _timer + _friendSpawnInterval;
    }
    if (_timer > _nextPresentSpawn) {
      PresentType present =
          _presentTypes[_random.nextInt(_presentTypes.length)];
      _storyHandler.nextPresents.add(present);
      _nextPresentSpawn = _timer + _presentSpawnInterval;
    }
  }
}
