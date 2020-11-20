import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/enemies/EffectType.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Bullet {
  PositionComponent _bullet;
  double _speedX;
  double _speedY;
  double _bulletSpeedX;
  double _bulletSpeedY;
  double _x, _y;
  EntityState _state;
  double damage;
  double speedfactor;

  Bullet(double x, double y, bulletSpeedX, bulletSpeedY, SpriteComponent bullet,
      this.speedfactor) {
    _bullet = bullet;
    _state = EntityState.Normal;
    setSpeed([0, 0]);
    damage = 1;

    this._x = x;
    this._y = y;
    this._bulletSpeedX =
        bulletSpeedX * speedfactor / (bulletSpeedX.abs() + bulletSpeedY.abs());
    this._bulletSpeedY =
        bulletSpeedY * speedfactor / (bulletSpeedX.abs() + bulletSpeedY.abs());
  }

  bool isDead() {
    return _state == EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  bool overlaps(Rect rect) {
    return _bullet.toRect().overlaps(rect);
  }

  Rect toRect() {
    return _bullet.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();
    _bullet.x = _x;
    _bullet.y = _y;
    _bullet.render(canvas);
    canvas.restore();
  }

  void resize() {
    _bullet.x = _x;
    _bullet.y = _y;
  }

  void update(double t, List<double> speed) {
    setSpeed(speed);
    _bullet.x = _x;
    _bullet.y = _y;
    _x = _bullet.x + _bulletSpeedX - t * _speedX * screenSize.width;
    _y = _bullet.y + _bulletSpeedY - t * _speedY * screenSize.width;

    if (_x < 0 ||
        _x > screenSize.width * 3 ||
        _y < 0 ||
        _y > screenSize.height * 2) die();
  }

  void setSpeed(List<double> speed) {
    _speedX = speed[0];
    _speedY = speed[1];
  }

  void die() {
    _state = EntityState.Dead;
  }

  EffectType getEffect() {
    return EffectType.None;
  }
}
