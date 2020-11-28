import 'dart:math';
import 'dart:ui';

import 'package:shootinggame/bullets/Bullet.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/friends/Friend.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/Spawner.dart';
import 'Level.dart';

class StoryHandler {
  List<Enemy> enemies;
  List<Bullet> bullets;
  List<SpecialBullet> _specialBullets;
  List<Friend> friends;
  Random _random;
  List<PresentType> nextPresents;
  bool levelUpdateble;
  double _levelTimer;

  List<Present> _presents;
  int levelNumber;
  Spawner spawner;
  Level _level;

  StoryHandler() {
    start();
  }

  void start() {
    enemies = List.empty(growable: true);
    bullets = List.empty(growable: true);
    _specialBullets = List.empty(growable: true);
    _presents = List.empty(growable: true);
    friends = List.empty(growable: true);
    nextPresents = List.empty(growable: true);
    _random = Random();
    _level = Level(0, this);
    spawner = Spawner(_level, this);
    levelNumber = 0;
    _levelTimer = 0;
    levelUpdateble = true;
  }

  void update(double t, List<double> bgSpeed, Player player) {
    // update level
    _levelTimer += t;
    if (levelUpdateble && _levelTimer > _level.timeToNextLevel) {
      _levelTimer = 0;
      levelNumber += 1;
      _level = Level(levelNumber, this);

      spawner = Spawner(_level, this);
    }
    //Add Enemies, Friends... from the Spawners Queues
    spawner.update(t);
    //Update the enemies
    enemies.forEach((e) {
      e.update(t, bgSpeed);
      if (e.isDead()) {
        if (nextPresents.isNotEmpty) {
          _presents.add(Present(e.x, e.y, nextPresents.first));
          nextPresents.removeAt(0);
        }
        player.score += e.getScore();
      } else {
        if (e.specialBullets.isNotEmpty) {
          _specialBullets.add(e.specialBullets.first);
          e.specialBullets.removeAt(0);
        }
        if (e.attacks()) {
          bullets.add(e.getAttack());
        }
      }
    });
    enemies.removeWhere((element) => element.isDead());

    //Update the friends
    friends.forEach((f) {
      f.update(t, bgSpeed);
      if (f.bullets.isNotEmpty) {
        _specialBullets.add(f.bullets.first);
        f.bullets.removeAt(0);
      }
    });
    friends.removeWhere((element) => element.isDead());

    //Update the presents
    for (int i = 0; i < _presents.length; i++) {
      _presents[i].update(t, bgSpeed);
      if (_presents[i].isDead()) {
        _presents.removeAt(i);
        i -= 1;
      }
    }

    //Update the bullets
    for (int i = 0; i < bullets.length; i++) {
      bullets[i].update(t, bgSpeed);
      if (bullets[i].overlaps(player.toRect())) {
        bullets[i].hitPlayer(player);
      }
    }
    bullets.removeWhere((element) => element.isDead());

    //Update the special bullets
    for (int i = 0; i < _specialBullets.length; i++) {
      _specialBullets[i].update(t, bgSpeed);
      if (_specialBullets[i].overlaps(player.toRect())) {
        _specialBullets[i].hitPlayer(player);
      }
    }
    _specialBullets.removeWhere((element) => element.isDead());
  }

  void render(Canvas canvas) {
    enemies.forEach((e) {
      e.render(canvas);
    });
    bullets.forEach((b) {
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

  List<Enemy> getEnemies() {
    return enemies;
  }

  List<Present> getPresents() {
    return _presents;
  }

  void resize() {
    enemies.forEach((e) {
      e.resize();
    });
    bullets.forEach((b) {
      b.resize();
    });
    _specialBullets.forEach((s) {
      s.resize();
    });
    _presents.forEach((p) {
      p.resize();
    });
    friends.forEach((f) {
      f.resize();
    });
  }
}
