import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/Bullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/bullets/GoldenBullet.dart';
import 'package:shootinggame/bullets/SmokeBullet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectState.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/effects/IceEffect.dart';
import 'package:shootinggame/effects/Shield.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/FireBullet.dart';
import 'package:shootinggame/friends/Friend.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/AttackType.dart';

import 'package:shootinggame/screens/player/ButtonBar.dart';
import 'package:shootinggame/screens/player/Healthbar.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../entities/WalkingEntity.dart';

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
  double specialPower;

  bool attack;
  BulletType bulletType;

  Player(int char) {
    bool debug = false;
    String playerPath;
    switch (char) {
      case 1:
        playerPath = 'elf';
        break;
      case 2:
        playerPath = 'elf2';
        break;
      case 3:
        playerPath = 'elf3';
        break;
      default:
    }
    _player = WalkingEntity(
        playerPath, 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
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
    speedfactor = 1;
    coins = 0;
    score = 0;
    slots = 0;
    bulletLifetimeFctr = 1;
    bulletSpeedFctr = 1;
    dmgFctr = 1;
    specialPower = 1;
    frozen = false;
    attackType = AttackType.Normal;
    bulletType = BulletType.One;
    _btnBar = ButtonBar(slots);
    if (debug) {
      slots = 3;
      _btnBar = ButtonBar(slots);
      bulletCount = 500;
      maxBulletCount = 1000;
      bulletType = BulletType.Two;
      health = 500;
      maxHealth = 500;
      bulletLifetimeFctr = 1.5;

      coins = 20;
      addAttack(AttackType.Fire, 5);
      addAttack(AttackType.Freeze, 5);
      addAttack(AttackType.Smoke, 5);
      // Effect iceEffect = IceEffect(this, null);
      // iceEffect.resize(getPosition());
      // effects.add(iceEffect);
      // Effect sparkle = Sparkle(this, null);
      // sparkle.resize(getPosition());
      // effects.add(sparkle);
    }
  }
  void onTapDown(TapDownDetails detail, List<Enemy> enemies,
      List<Friend> friends, List<double> speed, Function fn) {
    double sumSpeed = speed[0].abs() + speed[1].abs();
    speed[0] = speed[0] / sumSpeed * speedfactor * 0.2;
    speed[1] = speed[1] / sumSpeed * speedfactor * 0.2;

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
      e.resize(getPosition());
    });
    //screenManager.setSpeedfactor(5, true);
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
        effect.resize(getPosition());
        effects.add(effect);
        attackType = AttackType.Normal;
        break;
      case AttackType.Fire:
        FireBullet bullet = FireBullet(screenSize.width / 2,
            screenSize.height / 2, speed[0], speed[1], specialPower);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      case AttackType.Freeze:
        FreezeBullet bullet = FreezeBullet(screenSize.width / 2,
            screenSize.height / 2, speed[0], speed[1], specialPower);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      case AttackType.Night:
        GoldenBullet bullet = GoldenBullet(screenSize.width / 2,
            screenSize.height / 2, speed[0], speed[1], specialPower);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      case AttackType.Ice:
        IceEffect effect = IceEffect(this, null);
        effect.totalDuration = 15;
        effect.resize(getPosition());
        effects.add(effect);
        attackType = AttackType.Normal;
        break;
      case AttackType.Shield:
        StoryHandler storyHandler = screenManager.getStoryHandler();
        Shield shield = Shield(this, null, storyHandler);
        shield.resize(getPosition());
        effects.add(shield);
        attackType = AttackType.Normal;
        break;
      case AttackType.Smoke:
        SmokeBullet bullet = SmokeBullet(screenSize.width / 2,
            screenSize.height / 2, speed[0], speed[1], specialPower);
        bullet.resize();
        _specialBullets.add(bullet);
        attackType = AttackType.Normal;
        break;
      case AttackType.Tree:
        break;
      default:
        break;
    }
  }

  void die() {
    screenManager.endGame();
  }

  void addSlot() {
    slots += 1;
    _btnBar.addSlot();
  }

  void addAttack(AttackType type, int count) {
    _btnBar.addAttack(type, count);
  }

  void addTreeToSlots() {
    _btnBar.addTree();
  }

  Offset getPosition() {
    return Offset(_player.x, _player.y);
  }
}
