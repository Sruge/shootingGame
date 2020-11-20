import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:shootinggame/enemies/BasicEnemy.dart';
import 'package:shootinggame/enemies/Boss.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/enemies/Dealer.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/Friend.dart';
import 'package:shootinggame/enemies/FriendType.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/enemies/SpecialBullet.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';

class StoryHandler {
  final int maxSpawnInterval = 15000;
  final int minSpawnInterval = 15000;
  final int intervalChange = 3;
  final int maxEnemies = 4;
  int currentInterval;
  int nextSpawn;
  int nextBossSpawn;
  int nextFriendSpawn;
  List<Enemy> _enemies;
  List<Bullet> _bullets;
  List<SpecialBullet> _specialBullets;
  List<EnemyType> _enemyTypes;
  List<Friend> friends;
  Random _random;

  List<Present> _presents;

  StoryHandler() {
    start();
  }

  void start() {
    _enemyTypes = List.empty(growable: true);
    _enemyTypes.add(EnemyType.One);
    _enemyTypes.add(EnemyType.Two);
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
    nextBossSpawn = DateTime.now().millisecondsSinceEpoch + 2;
    nextFriendSpawn = DateTime.now().millisecondsSinceEpoch + 1;

    _enemies = List.empty(growable: true);

    _bullets = List.empty(growable: true);
    _specialBullets = List.empty(growable: true);

    _presents = List.empty(growable: true);
    friends = List.empty(growable: true);
    _random = Random();
  }

  void update(double t, List<double> bgSpeed, Player player) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp >= nextSpawn && _enemies.length < maxEnemies) {
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
      _enemies.add(getNewEnemy());
    }
    if (nowTimestamp >= nextBossSpawn) {
      nextBossSpawn = nowTimestamp + currentInterval * 8;
      Boss boss = Boss(EnemyType.Three);
      boss.resize();
      _enemies.add(boss);
    }
    if (nowTimestamp >= nextFriendSpawn) {
      nextFriendSpawn = nowTimestamp + currentInterval;
      Friend friend = Dealer();
      friend.resize();
      friends.add(friend);
    }
    for (int i = 0; i < _enemies.length; i++) {
      if (_enemies[i].isDead()) {
        addPresent(_enemies[i].x, _enemies[i].y);
        _enemies.removeAt(i);
        i -= 1;
      }
    }
    _enemies.forEach((e) {
      e.update(t, bgSpeed);
      if (e.specialBullets.isNotEmpty) {
        _specialBullets.add(e.specialBullets.first);
        e.specialBullets.removeAt(0);
      }
      if (e.attacks()) {
        _bullets.add(e.getAttack());
      }
    });
    friends.forEach((f) {
      f.update(t, bgSpeed);
    });

    for (int i = 0; i < _presents.length; i++) {
      _presents[i].update(t, bgSpeed);
      if (_presents[i].isDead()) {
        _presents.removeAt(i);
        i -= 1;
      }
    }
    for (int i = 0; i < _bullets.length; i++) {
      _bullets[i].update(t, bgSpeed);
      if (_bullets[i].overlaps(player.toRect())) {
        player.getHit(_bullets[i]);
        _bullets[i].die();
      }
    }
    for (int i = 0; i < _specialBullets.length; i++) {
      _specialBullets[i].update(t, bgSpeed);
      if (_specialBullets[i].overlaps(player.toRect())) {
        player.getHitWithSpecialBullet(_specialBullets[i]);
        _specialBullets[i].die();
      }
    }
    _bullets.removeWhere((element) => element.isDead());
    _specialBullets.removeWhere((element) => element.isDead());
    friends.removeWhere((element) => element.isDead());
  }

  void render(Canvas canvas) {
    _enemies.forEach((e) {
      e.render(canvas);
    });
    _bullets.forEach((b) {
      b.render(canvas);
    });
    _specialBullets.forEach((b) {
      b.render(canvas);
    });
    _presents.forEach((b) {
      b.render(canvas);
    });
    friends.forEach((f) {
      f.render(canvas);
    });
  }

  void resize() {
    _enemies.forEach((e) {
      e.resize();
    });
    _bullets.forEach((b) {
      b.resize();
    });
    _specialBullets.forEach((b) {
      b.resize();
    });
    _presents.forEach((b) {
      b.resize();
    });
    friends.forEach((f) {
      f.resize();
    });
  }

  Enemy getNewEnemy() {
    Random random = Random();
    int rand = random.nextInt(_enemyTypes.length);
    BasicEnemy enemy = BasicEnemy(_enemyTypes[rand]);
    enemy.resize();
    return enemy;
  }

  List<Enemy> getEnemies() {
    return _enemies;
  }

  List<Present> getPresents() {
    return _presents;
  }

  void addPresent(double x, double y) {
    int rand = _random.nextInt(10);
    if (rand > 7)
      _presents.add(Present(x, y, PresentType.Health));
    else if (rand > 4)
      _presents.add(Present(x, y, PresentType.Bullets));
    else if (rand > 0) _presents.add(Present(x, y, PresentType.Coin));
  }
}
