import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';

import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/enemies/BasicBullet.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/enemies/BulletType.dart';
import 'package:shootinggame/enemies/Effect.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/FireBullet.dart';
import 'package:shootinggame/enemies/Friend.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/enemies/SpecialBullet.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';
import 'package:shootinggame/screens/player/ButtonBar.dart';
import 'package:shootinggame/screens/player/Healthbar.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Player {
  AnimationComponent _player;
  PositionComponent _standingPlayer;
  Effect _effect;
  bool _isEffected;
  double _speedfactor;
  ButtonBar _btnBar;

  double health;
  double maxHealth;
  Healthbar _healthbar;
  bool _flipRender;

  List<Bullet> _bullets;
  List<SpecialBullet> _specialBullets;
  EffectType _effectType;
  bool move;
  int bulletCount;
  int maxBulletCount;
  int coins;
  int score;
  double bulletLifetimeFctr;
  double dmgFctr;

  Player(int char) {
    health = 20;
    maxHealth = 20;
    _healthbar = Healthbar(10, 10, bulletCount, coins, score);
    _flipRender = false;
    _bullets = List.empty(growable: true);
    _specialBullets = List.empty(growable: true);
    move = false;
    _effectType = EffectType.None;
    _isEffected = false;
    bulletCount = 40;
    maxBulletCount = 50;
    _speedfactor = 0.2;
    coins = 0;
    score = 0;
    _btnBar = ButtonBar();
    bulletLifetimeFctr = 1;
    dmgFctr = 1;
    // _btnBar.add(EffectType.Fire);
    // _btnBar.add(EffectType.Purple);

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

    final spritesheet = SpriteSheet(
        imageName: playerPath,
        textureWidth: 32,
        textureHeight: 48,
        columns: 4,
        rows: 4);
    final animation = spritesheet.createAnimation(1, stepTime: 0.1);
    _player = AnimationComponent(100, 100, animation);
    _standingPlayer =
        SpriteComponent.fromSprite(100, 100, (spritesheet.getSprite(0, 0)));
  }
  void onTapDown(TapDownDetails detail, List<Enemy> enemies,
      List<Friend> friends, List<double> speed, Function fn) {
    move = true;
    _healthbar.onTapDown(detail, fn);
    if (_effectType == EffectType.Freeze) {
      move = false;
    } else {
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
    if (move) {
      _player.renderFlipX = _flipRender;
      canvas.save();
      _player.render(canvas);
      canvas.restore();
    } else {
      canvas.save();
      _standingPlayer.render(canvas);
      canvas.restore();
    }
    if (_isEffected) {
      canvas.save();
      _effect.render(canvas);
      canvas.restore();
    }

    _bullets.forEach((b) {
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
    _healthbar.render(canvas);
    canvas.restore();
    canvas.save();
    _btnBar.render(canvas);
    canvas.restore();
  }

  void resize() {
    _healthbar.resize();
    _btnBar.resize();
    _player.x = (screenSize.width - screenSize.width * 0.06) / 2;
    _player.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _player.width = screenSize.width * 0.06;
    _player.height = screenSize.height * 0.14;
    _standingPlayer.x = (screenSize.width - screenSize.width * 0.06) / 2;
    _standingPlayer.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _standingPlayer.width = screenSize.width * 0.06;
    _standingPlayer.height = screenSize.height * 0.14;
    _bullets.forEach((b) {
      b.resize();
    });
    _specialBullets.forEach((b) {
      b.resize();
    });
  }

  void update(double t, List<double> speed, List<Enemy> enemies,
      List<Present> presents) {
    _player.update((t));

    _healthbar.update(maxHealth, health, bulletCount, score, coins);
    _btnBar.update(t);
    presents.forEach((present) {
      if (present.overlaps(_player.toRect())) {
        present.hit(this);
        present.die();
      }
    });
    for (int i = 0; i < _bullets.length; i++) {
      _bullets[i].update(t, speed);
      enemies.forEach((e) {
        if (e.overlaps(_bullets[i].toRect())) {
          e.getHit(_bullets[i]);
          _bullets[i].die();
        }
      });
    }
    for (int i = 0; i < _specialBullets.length; i++) {
      _specialBullets[i].update(t, speed);
      enemies.forEach((e) {
        if (e.overlaps(_specialBullets[i].toRect())) {
          e.getHitWithSpecialBullet(_specialBullets[i]);
          _specialBullets[i].die();
        }
      });
    }
    _bullets.removeWhere((element) => element.isDead());
    _specialBullets.removeWhere((element) => element.isDead());
    if (_isEffected) {
      _effect.update(t, _player.x, _player.y);
      if (_effect.getType() == EffectType.None) {
        _isEffected = false;
      }
    }

    setFlipRender(speed[0]);
  }

  void getHit(Bullet bullet) {
    if (health > 0) health -= bullet.damage;
    if (health <= 0) {
      die();
    }
  }

  void getHitWithSpecialBullet(SpecialBullet specialBullet) {
    if (health > 0) health -= specialBullet.damage;
    switch (specialBullet.getEffect()) {
      case EffectType.Freeze:
        _effect = Effect(EffectType.Freeze, 2);
        _effect.resize(_player.x, _player.x);
        _isEffected = true;
        break;
      case EffectType.Fire:
        _effect = Effect(EffectType.Fire, 2);
        _effect.resize(_player.x, _player.x);
        _isEffected = true;
        break;
      default:
        break;
    }
    if (health <= 0) {
      print('The Player has died, reviving!');
      health = 20;
    }
  }

  Rect toRect() {
    return _player.toRect();
  }

  void setFlipRender(double speedX) {
    if (speedX < 0) _flipRender = false;
    if (speedX > 0) _flipRender = true;
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
          BulletType.Two,
          bulletLifetimeFctr,
          dmgFctr);
      bullet.resize();
      _bullets.add(bullet);
      bulletCount -= 1;
    }
  }

  void shootSpecial(Offset pos, List<double> speed) {
    if (bulletCount > 0) {
      FireBullet bullet = FireBullet(
          screenSize.width / 2, screenSize.height / 2, speed[0], speed[1]);
      bullet.resize();
      _specialBullets.add(bullet);
      bulletCount -= 1;
    }
  }

  void die() {
    print('The Player has died, reviving!');
    health = 20;
  }
}
