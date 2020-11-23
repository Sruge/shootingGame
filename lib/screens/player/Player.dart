import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/Bullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectState.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/FireBullet.dart';
import 'package:shootinggame/enemies/Friend.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';

import 'package:shootinggame/screens/player/ButtonBar.dart';
import 'package:shootinggame/screens/player/Healthbar.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'WalkingEntity.dart';

class Player {
  WalkingEntity _player;
  List<Effect> effects;
  double speedfactor;
  ButtonBar _btnBar;

  double health;
  double maxHealth;
  Healthbar _healthbar;

  List<Bullet> bullets;
  List<SpecialBullet> _specialBullets;
  bool move;
  int bulletCount;
  int maxBulletCount;
  int coins;
  int score;
  double bulletLifetimeFctr;
  double dmgFctr;
  bool frozen;

  Player(int char) {
    health = 20;
    maxHealth = 20;
    _healthbar = Healthbar(10, 10, bulletCount, coins, score);
    bullets = List.empty(growable: true);
    _specialBullets = List.empty(growable: true);
    move = false;
    effects = List.empty(growable: true);
    bulletCount = 100;
    maxBulletCount = 500;
    speedfactor = 0.2;
    coins = 0;
    score = 0;
    _btnBar = ButtonBar();
    bulletLifetimeFctr = 0.7;
    dmgFctr = 2;
    frozen = false;
    _btnBar.add(EffectType.Fire);
    //_btnBar.add(EffectType.Fire);
    //_btnBar.add(EffectType.Fire);

    String playerPath;
    switch (char) {
      case 1:
        playerPath = 'elf.png';
        break;
      case 2:
        playerPath = 'elf2.png';
        break;
      case 3:
        playerPath = 'elf3.png';
        break;
      default:
    }

    _player = WalkingEntity(
        playerPath, 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
  }
  void onTapDown(TapDownDetails detail, List<Enemy> enemies,
      List<Friend> friends, List<double> speed, Function fn) {
    if (!frozen) {
      move = true;
      _healthbar.onTapDown(detail, fn);

      for (int i = 0; i < enemies.length; i++) {
        if (enemies[i].contains(detail.globalPosition)) {
          move = false;
          //shootSpecial(detail.globalPosition, speed);
          shoot(detail.globalPosition, speed);
          break;
        }
      }
      if (move) {
        for (int i = 0; i < friends.length; i++) {
          if (friends[i].contains(detail.globalPosition)) {
            if (friends[i].overlaps(_player.toRect())) {
              move = false;
              friends[i].die();
              friends[i].trigger();
            }
          }
        }
      }
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    _player.render(canvas);
    canvas.restore();
    effects.forEach((effect) {
      canvas.save();
      effect.render(canvas);
      canvas.restore();
    });
    bullets.forEach((b) {
      canvas.save();
      b.render(canvas);
      canvas.restore();
    });
    _specialBullets.forEach((b) {
      canvas.save();
      b.render(canvas);
      canvas.restore();
    });
    canvas.save();
    _btnBar.render(canvas);
    canvas.restore();
    canvas.save();
    _healthbar.render(canvas);
    canvas.restore();
  }

  void resize() {
    _healthbar.resize();
    _btnBar.resize();
    _player.x = (screenSize.width - screenSize.width * 0.06) / 2;
    _player.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _player.resize();
    bullets.forEach((b) {
      b.resize();
    });
    _specialBullets.forEach((b) {
      b.resize();
    });
    effects.forEach((e) {
      e.resize(_player.x, _player.y);
    });
  }

  void update(double t, List<double> speed, List<Enemy> enemies,
      List<Present> presents) {
    if (health <= 0) die();
    _player.update(t, speed);

    _healthbar.update(maxHealth, health, bulletCount, score, coins);
    _btnBar.update(t);
    presents.forEach((present) {
      if (present.overlaps(_player.toRect())) {
        present.hit(this);
        present.die();
      }
    });
    for (int i = 0; i < bullets.length; i++) {
      bullets[i].update(t, speed);
      enemies.forEach((e) {
        if (e.overlaps(bullets[i].toRect())) {
          e.getHit(bullets[i]);
          bullets[i].die();
        }
      });
    }
    for (int i = 0; i < _specialBullets.length; i++) {
      _specialBullets[i].update(t, speed);
      enemies.forEach((e) {
        if (e.overlaps(_specialBullets[i].toRect())) {
          _specialBullets[i].hitEnemy(e);
        }
      });
    }
    bullets.removeWhere((element) => element.isDead());
    _specialBullets.removeWhere((element) => element.isDead());
    effects.forEach((element) {
      element.update(t, _player.x, _player.y);
    });
    effects.removeWhere((element) => element.state == EffectState.Ended);
  }

  void getHit(Bullet bullet) {
    if (health > 0) health -= bullet.damage;
    if (health <= 0) {
      die();
    }
  }

  Rect toRect() {
    return _player.toRect();
  }

  bool isMoving() {
    return move;
  }

  void shoot(Offset pos, List<double> speed) {
    if (bulletCount > 0) {
      BasicBullet bullet = BasicBullet(
          screenSize.width / 2,
          screenSize.height / 2,
          speed[0],
          speed[1],
          BulletType.One,
          bulletLifetimeFctr,
          dmgFctr);
      bullet.resize();
      bullets.add(bullet);
      bulletCount -= 1;
    }
  }

  void shootSpecial(Offset pos, List<double> speed) {
    if (bulletCount > 0) {
      FreezeBullet bullet = FreezeBullet(
          screenSize.width / 2, screenSize.height / 2, speed[0], speed[1]);
      bullet.resize();
      _specialBullets.add(bullet);
      bulletCount -= 1;
    }
  }

  void die() {
    health = 20;
  }
}
