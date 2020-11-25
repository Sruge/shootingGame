import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/Bullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/bullets/GoldenBullet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectState.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/effects/IceEffect.dart';
import 'package:shootinggame/effects/Sparkle.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/FireBullet.dart';
import 'package:shootinggame/friends/Friend.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/screens/player/AttackType.dart';

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
  AttackType attackType;

  List<Bullet> bullets;
  List<SpecialBullet> _specialBullets;
  bool move;
  int bulletCount;
  int maxBulletCount;
  int coins;
  int score;
  double bulletLifetimeFctr;
  double bulletSpeedFctr;
  double dmgFctr;
  bool frozen;
  int slots;

  bool attack;
  BulletType bulletType;

  Player(int char) {
    bool debug = true;
    health = 200;
    maxHealth = 200;
    _healthbar = Healthbar(10, 10, bulletCount, coins, score);
    bullets = List.empty(growable: true);
    _specialBullets = List.empty(growable: true);
    move = false;
    attack = false;
    effects = List.empty(growable: true);
    bulletCount = 100;
    maxBulletCount = 200;
    speedfactor = 0.2;
    coins = 0;
    score = 0;
    slots = 0;
    bulletLifetimeFctr = 0.7;
    bulletSpeedFctr = 1;
    dmgFctr = 1;
    frozen = false;
    attackType = AttackType.Normal;
    bulletType = BulletType.One;
    if (debug) {
      slots = 3;
      bulletCount = 500;
      maxBulletCount = 1000;
      _btnBar = ButtonBar(slots);

      coins = 20;
      addAttack(AttackType.Fire, 5);
      addAttack(AttackType.Freeze, 5);
      addAttack(AttackType.Heal, 5);
      Effect iceEffect = IceEffect(this, null);
      iceEffect.resize(0, 0);
      effects.add(iceEffect);
      Effect sparkle = Sparkle(this, null);
      sparkle.resize(0, 0);
      effects.add(sparkle);
    }
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
    move = true;
    attack = true;

    if (!frozen) {
      _healthbar.onTapDown(detail, fn, this);
      _btnBar.onTapDown(detail, this);
      if (move) {
        if (attackType == AttackType.Normal) {
          for (int i = 0; i < enemies.length; i++) {
            if (enemies[i].contains(detail.globalPosition)) {
              move = false;
              shoot(detail.globalPosition, speed);
              break;
            }
          }
          if (move) {
            for (int i = 0; i < friends.length; i++) {
              if (friends[i].contains(detail.globalPosition)) {
                if (friends[i].overlaps(_player.toRect())) {
                  move = false;
                  friends[i].trigger();
                  friends[i].die();
                }
              }
            }
          }
        } else if (move) {
          shoot(detail.globalPosition, speed);
          _btnBar.deactivateAll();
          move = false;
        }
      }
    } else {
      move = false;
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
          bullets[i].hitEnemy(e);
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
    _btnBar.reduceCount(attackType);
    switch (attackType) {
      case AttackType.Normal:
        if (bulletCount > 0) {
          BasicBullet bullet = BasicBullet(
              screenSize.width / 2,
              screenSize.height / 2,
              speed[0],
              speed[1],
              bulletType,
              bulletLifetimeFctr,
              dmgFctr,
              bulletSpeedFctr);
          bullet.resize();
          bullets.add(bullet);
          bulletCount -= 1;
        }
        break;
      case AttackType.Heal:
        HealEffect effect = HealEffect(this, null);
        effect.totalDuration = 5;
        effect.resize(_player.x, _player.y);
        effects.add(effect);
        attackType = AttackType.Normal;
        break;
      case AttackType.Fire:
        FireBullet bullet = FireBullet(
            screenSize.width / 2,
            screenSize.height / 2,
            speed[0],
            speed[1],
            bulletLifetimeFctr,
            dmgFctr,
            bulletSpeedFctr);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      case AttackType.Freeze:
        FreezeBullet bullet = FreezeBullet(
            screenSize.width / 2,
            screenSize.height / 2,
            speed[0],
            speed[1],
            bulletLifetimeFctr,
            dmgFctr,
            bulletSpeedFctr);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      case AttackType.Night:
        GoldenBullet bullet = GoldenBullet(
            screenSize.width / 2,
            screenSize.height / 2,
            speed[0],
            speed[1],
            bulletLifetimeFctr,
            dmgFctr,
            bulletSpeedFctr);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      default:
        break;
    }
  }

  void die() {
    health = maxHealth;
  }

  void addSlot() {
    slots += 1;
    _btnBar.addSlot();
  }

  void addAttack(AttackType type, int count) {
    _btnBar.addAttack(type, count);
  }
}
