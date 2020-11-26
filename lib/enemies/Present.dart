import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/enemies/PresentType.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/AttackType.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Present {
  double _speedX;
  double _speedY;
  double _x, _y;
  EntityState _state;
  double _lifetimeUpToNow;
  double _lifetimeMax;
  PresentType _type;
  AnimationComponent _present;

  Present(double x, double y, this._type) {
    String _image;
    switch (_type) {
      case PresentType.Health:
        _image = 'greenPresentAnimation';
        break;
      case PresentType.Bullets:
        _image = 'brownPresentAnimation';
        break;
      case PresentType.Blue:
        _image = 'bluePresentAnimation';
        break;
      case PresentType.Red:
        _image = 'redPresentAnimation';
        break;
      case PresentType.Golden:
        _image = 'goldenPresentAnimation';
        break;
      case PresentType.Colored:
        _image = 'coloredPresentAnimation';
        break;
      case PresentType.Coin:
        _image = 'coin3';
        break;
      default:
        break;
    }

    final sprShe = SpriteSheet(
        imageName: '$_image.png',
        textureWidth: 128,
        textureHeight: 128,
        columns: 4,
        rows: 1);
    Animation animation = sprShe.createAnimation(0, stepTime: 0.2);
    _present = AnimationComponent(24, 24, animation);
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

  bool overlaps(Rect rect) {
    return _present.toRect().overlaps(rect);
  }

  Rect toRect() {
    return _present.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();
    _present.x = _x;
    _present.y = _y;
    _present.render(canvas);
    canvas.restore();
  }

  void resize() {
    _present.x = _x;
    _present.y = _y;
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
      _present.x = _x;
      _present.y = _y;
      _present.update(t);
    } else {
      _present.x = _x;
      _present.y = _y;
      _x = _present.x - t * _speedX * screenSize.width;
      _y = _present.y - t * _speedY * screenSize.width;
    }

    _present.update(t);
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
        effect.resize(player.getPosition());
        player.effects.add(effect);
        if (player.health > player.maxHealth) player.health = player.maxHealth;
        break;
      case PresentType.Bullets:
        player.bulletCount = player.maxBulletCount;
        break;
      case PresentType.Coin:
        player.coins += 1;
        break;
      case PresentType.Blue:
        Random random = Random();
        player.addAttack(
            AttackType.values[random.nextInt(AttackType.values.length)], 3);
        break;
      default:
        break;
    }
  }
}
