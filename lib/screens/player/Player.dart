import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/enemies/BasicBullet.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/enemies/BulletType.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/Fire.dart';
import 'package:shootinggame/enemies/Friend.dart';
import 'package:shootinggame/enemies/Present.dart';
import 'package:shootinggame/enemies/SpecialBullet.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';
import 'package:shootinggame/screens/util/Healthbar.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Player {
  AnimationComponent _player;
  PositionComponent _standingPlayer;
  AnimationComponent _fireEffectImage;
  Animation _freezeAnimation;
  Animation _fireAnimation;
  AnimationComponent _freezeEffectImage;
  double _speedfactor;

  double health;
  double maxHealth;
  Healthbar _healthbar;
  bool _flipRender;

  List<Bullet> _bullets;
  EffectType _effect;
  double _effectTime;
  bool move;
  int bulletCount;
  List<int> _burnDamage;
  int maxBulletCount;
  int coins;

  double _effectTimer;

  num _nextBurn;

  Player(int char) {
    health = 20;
    maxHealth = 20;
    _healthbar = Healthbar(10, 10, bulletCount);
    _flipRender = false;
    _bullets = List.empty(growable: true);
    _burnDamage = List.empty(growable: true);
    move = false;
    _effect = EffectType.None;
    _effectTime = 0;
    _effectTimer = 0;
    _nextBurn = 1;
    bulletCount = 40;
    maxBulletCount = 50;
    _speedfactor = 0.2;
    coins = 0;
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

    final fireSprShe = SpriteSheet(
        imageName: 'fire.png',
        textureWidth: 32,
        textureHeight: 24,
        columns: 4,
        rows: 1);
    _fireAnimation = fireSprShe.createAnimation(0, stepTime: 0.1);
    _fireEffectImage = AnimationComponent(100, 100, _fireAnimation);

    final freezeSprShe = SpriteSheet(
        imageName: 'toxed.png',
        textureWidth: 32,
        textureHeight: 24,
        columns: 4,
        rows: 1);
    _freezeAnimation = freezeSprShe.createAnimation(0, stepTime: 0.1);
    _freezeEffectImage = AnimationComponent(100, 100, _freezeAnimation);

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
    if (_effect == EffectType.Freeze) {
      move = false;
    } else {
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
              friends[i].die();
              _speedfactor += _speedfactor * 0.1;
              screenManager.setSpeedfactor(_speedfactor);
              screenManager.switchScreen(ScreenState.kCharacterScreen);
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
      _player.render(canvas);
    } else {
      _standingPlayer.render(canvas);
    }
    canvas.restore();
    if (_effect == EffectType.Fire) {
      canvas.save();
      _fireEffectImage.render(canvas);
      canvas.restore();
    } else if (_effect == EffectType.Freeze) {
      canvas.save();
      _freezeEffectImage.render(canvas);
      canvas.restore();
    }
    _bullets.forEach((b) {
      b.render(canvas);
    });
    _healthbar.render(canvas);
  }

  void resize() {
    _player.x = (screenSize.width - screenSize.width * 0.06) / 2;
    _player.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _player.width = screenSize.width * 0.06;
    _player.height = screenSize.height * 0.14;
    _standingPlayer.x = (screenSize.width - screenSize.width * 0.06) / 2;
    _standingPlayer.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _standingPlayer.width = screenSize.width * 0.06;
    _standingPlayer.height = screenSize.height * 0.14;
    _fireEffectImage.x = (screenSize.width - screenSize.width * 0.06) / 2 - 10;
    _fireEffectImage.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _fireEffectImage.width = screenSize.width * 0.06 + 20;
    _fireEffectImage.height = screenSize.height * 0.14;
    _freezeEffectImage.x =
        (screenSize.width - screenSize.width * 0.06) / 2 - 10;
    _freezeEffectImage.y = (screenSize.height - screenSize.height * 0.14) / 2;
    _freezeEffectImage.width = screenSize.width * 0.06 + 20;
    _freezeEffectImage.height = screenSize.height * 0.14;
    _bullets.forEach((b) {
      b.resize();
    });
  }

  void update(double t, List<double> speed, List<Enemy> enemies,
      List<Present> presents) {
    if (_effect != EffectType.None) {
      _effectTimer += t;
      if (_effect == EffectType.Fire &&
          _effectTimer > _nextBurn &&
          _burnDamage.isNotEmpty) {
        health -= _burnDamage.first;
        _burnDamage.removeAt(0);
        _nextBurn += 1;
        if (health <= 0) {
          die();
        }
      }
      if (_effectTimer > _effectTime) {
        _effect = EffectType.None;
        _effectTimer = 0;
        _nextBurn = 1;
      }
    }
    _player.update((t));
    _fireEffectImage.update(t);
    _freezeEffectImage.update(t);
    _healthbar.updateRect(maxHealth, health);
    _healthbar.updateBulletCount(bulletCount);
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
    _bullets.removeWhere((element) => element.isDead());

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
        _effect = EffectType.Freeze;
        _effectTime = 3;
        _effectTimer = 0;
        break;
      case EffectType.Fire:
        _effect = EffectType.Fire;
        _effectTime = 5;
        _effectTimer = 0;
        _burnDamage = [1, 2, 3, 4];
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
      BasicBullet bullet = BasicBullet(screenSize.width / 2,
          screenSize.height / 2, speed[0], speed[1], BulletType.Two);
      bullet.resize();
      _bullets.add(bullet);
      bulletCount -= 1;
    }
  }

  void fire(Offset pos) {
    Fire fire = Fire(screenSize.width / 2, screenSize.height / 2, pos);
    fire.resize();
    _bullets.add(fire);
  }

  void die() {
    print('The Player has died, reviving!');
    health = 20;
  }
}
