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

  Bullet(this._x, this._y, this._bulletSpeedX, this._bulletSpeedY) {
    bullet = SpriteComponent.square(7, 'bullet.png');
    _state = EntityState.Normal;
    setSpeed([0, 0]);
    _timer = 0;
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
    _bulletSpeedX *= speedfactor;
    _bulletSpeedY *= speedfactor;
  }

  void update(double t, List<double> speed) {
    _timer += t;
    setSpeed(speed);

    _x = _x + _bulletSpeedX * speedfactor - t * _speedX * screenSize.width;
    _y = _y + _bulletSpeedY * speedfactor - t * _speedY * screenSize.width;
    if (_timer > lifetime) die();
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
