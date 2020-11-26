import 'dart:math';

import 'package:shootinggame/enemies/BasicEnemy.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/friends/Dealer.dart';
import 'package:shootinggame/friends/Firetree.dart';
import 'package:shootinggame/friends/Friend.dart';
import 'package:shootinggame/friends/FriendType.dart';
import 'package:shootinggame/friends/Tree.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import 'Level.dart';

class Spawner {
  double spawnInterval;
  double _bossSpawnInterval;
  double _friendSpawnInterval;
  double _presentSpawnInterval;
  double _treeSpawnInterval;
  double maxEnemies;
  double nextSpawn;
  double _nextBossSpawn;
  double _nextFriendSpawn;
  double _nextPresentSpawn;
  double _nextTreeSpawn;
  double _dmgMultiplier;
  double _attackRange;
  double _bulletLifetime;
  double _attackInterval;
  double _healthMulti;
  double _enemySpeed;
  double _enemyBulletSpeed;
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
    spawnInterval = level.spawnInterval;
    _bossSpawnInterval = level.bossSpawnInterval;
    _friendSpawnInterval = level.friendSpawnInterval;
    _presentSpawnInterval = level.presentSpawnInterval;
    _treeSpawnInterval = level.treeSpawnInterval;
    _enemyTypes = level.enemyTypes;
    _enemyBulletSpeed = level.enemyBulletSpeed;
    maxEnemies = level.maxEnemies;
    nextSpawn = 0;
    _nextBossSpawn = 2;
    _nextFriendSpawn = _friendSpawnInterval;
    _nextPresentSpawn = _presentSpawnInterval;
    _nextTreeSpawn = 1;
    bosses = level.bosses;
    _presentTypes = level.presentTypes;
    _attackInterval = level.attackIntervalMultiplier;
    _attackRange = level.attackRangeMultiplier;
    _dmgMultiplier = level.dmgMultiplier;
    _bulletLifetime = level.bulletLifetimeMultiplier;
    _healthMulti = level.healthMulti;
    _enemySpeed = level.enemySpeedMultiplier;
    maxEnemies = level.maxEnemies;
  }

  update(double t) {
    _timer += t;
    if (_timer > nextSpawn && _storyHandler.enemies.length <= maxEnemies) {
      BasicEnemy enemy = BasicEnemy(
          _enemyTypes[_random.nextInt(_enemyTypes.length)],
          _dmgMultiplier,
          _attackRange,
          _attackInterval,
          _bulletLifetime,
          _healthMulti,
          _enemySpeed,
          _enemyBulletSpeed);
      enemy.resize();
      _storyHandler.enemies.add(enemy);
      nextSpawn = _timer + spawnInterval;
    }
    if (_timer > _nextBossSpawn && bosses.isNotEmpty) {
      int rand = _random.nextInt(bosses.length);
      _storyHandler.enemies.add(bosses[rand]);
      bosses.removeAt(rand);
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
    if (_timer > _nextTreeSpawn) {
      screenManager.setTree(2);
      _nextTreeSpawn = _timer + _treeSpawnInterval;
    }
  }

  void setTree(double x, double y, double power) {
    Friend tree = Firetree(x, y, power);
    tree.resize();
    _storyHandler.friends.add(tree);
  }
}
