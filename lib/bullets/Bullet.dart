import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Bullet {
  PositionComponent bullet;
  double _speedX;
  double _speedY;
  double _bulletSpeedX;
  double _bulletSpeedY;
  double _x, _y;
  EntityState _state;
  double damage;
  double speedfactor;
  double lifetime, _timer;

  Bullet(double x, double y, bulletSpeedX, bulletSpeedY, this.speedfactor) {
    bullet = SpriteComponent.square(7, 'bullet.png');
    _state = EntityState.Normal;
    setSpeed([0, 0]);
    damage = 20;
    _timer = 0;
    lifetime = 1;

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
    return bullet.toRect().overlaps(rect);
  }

  Rect toRect() {
    return bullet.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();
    bullet.x = _x;
    bullet.y = _y;
    bullet.render(canvas);
    canvas.restore();
  }

  void resize() {
    bullet.x = _x;
    bullet.y = _y;
  }

  void update(double t, List<double> speed) {
    _timer += t;
    setSpeed(speed);
    bullet.x = _x;
    bullet.y = _y;
    _x = bullet.x + _bulletSpeedX - t * _speedX * screenSize.width;
    _y = bullet.y + _bulletSpeedY - t * _speedY * screenSize.width;
    if (_timer > lifetime) die();

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

  void hitPlayer(Player player) {
    player.health -= damage;
    die();
  }

  void hitEnemy(Enemy enemy) {
    enemy.health -= damage;
    die();
  }
}
