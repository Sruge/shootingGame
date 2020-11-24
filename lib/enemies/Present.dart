import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/enemies/PresentType.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/AttackType.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Present {
  PositionComponent _present;
  double _speedX;
  double _speedY;
  double _x, _y;
  EntityState _state;
  double _lifetimeUpToNow;
  double _lifetimeMax;
  PresentType _type;
  AnimationComponent _coin;

  Present(double x, double y, this._type) {
    switch (_type) {
      case PresentType.Health:
        _present = SpriteComponent.square(32, 'greenPresent.png');
        break;
      case PresentType.Bullets:
        _present = SpriteComponent.square(32, 'brownPresent.png');

        break;
      case PresentType.Freeze:
        _present = SpriteComponent.square(32, 'bluePresent.png');
        break;
      case PresentType.Coin:
        final coinSheet = SpriteSheet(
            imageName: 'coin3.png',
            textureWidth: 128,
            textureHeight: 128,
            columns: 4,
            rows: 1);
        Animation coinimation = coinSheet.createAnimation(0, stepTime: 0.2);
        _coin = AnimationComponent(24, 24, coinimation);
        break;
      default:
        break;
    }
    _state = EntityState.Normal;
    _lifetimeUpToNow = 0;
    _lifetimeMax = 4;
    setSpeed([0, 0]);

    this._x = x;
    this._y = y;
  }

  bool isDead() {
    return _state == EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  bool overlaps(Rect rect) {
    if (_type == PresentType.Coin) {
      return _coin.toRect().overlaps(rect);
    } else {
      return _present.toRect().overlaps(rect);
    }
  }

  Rect toRect() {
    return _present.toRect();
  }

  void render(Canvas canvas) {
    if (_type == PresentType.Coin) {
      canvas.save();
      _coin.x = _x;
      _coin.y = _y;
      _coin.render(canvas);
      canvas.restore();
    } else {
      canvas.save();
      _present.x = _x;
      _present.y = _y;
      _present.render(canvas);
      canvas.restore();
    }
  }

  void resize() {
    if (_type == PresentType.Coin) {
      _coin.x = _x;
      _coin.y = _y;
    } else {
      _present.x = _x;
      _present.y = _y;
    }
  }

  void update(double t, List<double> speed) {
    _lifetimeUpToNow += t;
    if (_lifetimeUpToNow > _lifetimeMax) {
      die();
    }
    setSpeed(speed);
    if (_type == PresentType.Coin) {
      _x = _x - t * _speedX * screenSize.width;
      _y = _y - t * _speedY * screenSize.width;
      _coin.x = _x;
      _coin.y = _y;
      _coin.update(t);
    } else {
      _present.x = _x;
      _present.y = _y;
      _x = _present.x - t * _speedX * screenSize.width;
      _y = _present.y - t * _speedY * screenSize.width;
    }
  }

  void setSpeed(List<double> speed) {
    _speedX = speed[0];
    _speedY = speed[1];
  }

  void die() {
    _state = EntityState.Dead;
  }

  void hit(Player player) {
    switch (_type) {
      case PresentType.Health:
        player.health += player.maxHealth * 0.1;
        Effect effect = HealEffect(player, null);
        effect.resize(0, 0);
        player.effects.add(effect);
        if (player.health > player.maxHealth) player.health = player.maxHealth;
        break;
      case PresentType.Bullets:
        player.bulletCount += 15;
        if (player.bulletCount > player.maxBulletCount)
          player.bulletCount = player.maxBulletCount;
        break;
      case PresentType.Coin:
        player.coins += 1;
        break;
      case PresentType.Freeze:
        Random random = Random();
        player.addAttack(
            AttackType.values[random.nextInt(AttackType.values.length)], 3);
        break;
      default:
        break;
    }
  }
}
