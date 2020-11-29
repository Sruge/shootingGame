import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:shootinggame/enemies/BasicEnemy.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/friends/BulletTypeDealer.dart';
import 'package:shootinggame/friends/StandardDealer.dart';
import 'package:shootinggame/friends/SpecialDealer.dart';
import 'package:shootinggame/friends/Friend.dart';
import 'package:shootinggame/friends/Tree.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
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
  double _treePower;
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
    nextSpawn = spawnInterval;
    _nextBossSpawn = _bossSpawnInterval;
    _nextFriendSpawn = _friendSpawnInterval;
    _nextPresentSpawn = _presentSpawnInterval;
    _nextTreeSpawn = _treeSpawnInterval;
    bosses = level.bosses;
    _presentTypes = level.presentTypes;
    _attackInterval = level.attackIntervalMultiplier;
    _attackRange = level.attackRangeMultiplier;
    _dmgMultiplier = level.dmgMultiplier;
    _bulletLifetime = level.bulletLifetimeMultiplier;
    _healthMulti = level.healthMulti;
    _enemySpeed = level.enemySpeedMultiplier;
    maxEnemies = level.maxEnemies;
    _treePower = level.treePower;

    if (level.level == 0) {
      StandardDealer stdDealer = StandardDealer();
      stdDealer.resize();
      storyHandler.friends.add(stdDealer);
    }
  }

  update(double t) {
    _timer += t;

    //Add enemies if the time has come and there are not too many yet
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

      //There is a 7 percent chance that "nextSpawn" does
      //not get increased and so another enemy gets added
      if (_random.nextDouble() > 0.07) {
        nextSpawn = _timer + spawnInterval + _random.nextInt(3);
      }
    }

    //Add boss if its time to
    if (_timer > _nextBossSpawn && bosses.isNotEmpty) {
      int rand = _random.nextInt(bosses.length);

      _storyHandler.enemies.add(bosses[rand]);
      bosses[rand].getCalledToTheBattlefield();
      bosses.removeAt(rand);
      _nextBossSpawn = _timer + _bossSpawnInterval + _random.nextInt(40);
    }

    //Add a SpecialDealer or (with small probability) a BulletTypeDealer
    if (_timer > _nextFriendSpawn) {
      Friend friend;
      if (_random.nextDouble() > 0.85) {
        friend = BulletTypeDealer();
      } else {
        friend = SpecialDealer();
      }
      friend.resize();
      _storyHandler.friends.add(friend);
      _nextFriendSpawn = _timer + _friendSpawnInterval + _random.nextInt(20);
    }

    //Add a present to the queue which will be dropped if next enemy dies
    if (_timer > _nextPresentSpawn) {
      if (_random.nextDouble() > 0.3) {
        //70% Chance to get a coin
        _storyHandler.nextPresents.add(PresentType.Coin);
      } else {
        PresentType present =
            _presentTypes[_random.nextInt(_presentTypes.length)];
        _storyHandler.nextPresents.add(present);
      }
      //After a present gets added to the queue there is always a 10 percent
      //chance that another present gets added
      if (_random.nextDouble() > 0.1) {
        _nextPresentSpawn = _timer + _presentSpawnInterval + _random.nextInt(3);
      }
    }

    //If its time to add a tree
    if (_timer > _nextTreeSpawn) {
      setTree(_treePower);
      _nextTreeSpawn = _timer + _treeSpawnInterval;
    }
  }

  void setTree(double power) {
    Random random = Random();
    Offset bgPos = screenManager.getBgPos();
    double x = random.nextDouble() * (bgPos.dx + screenSize.width * 2);
    double y = random.nextDouble() * (bgPos.dy + screenSize.width * 2);
    Friend tree = Tree(x, y, power);
    tree.resize();
    _storyHandler.friends.add(tree);
  }
}
