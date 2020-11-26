import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shootinggame/enemies/Enemy.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class SpecialBullet {
  AnimationComponent specialBullet;
  double _speedX;
  double _speedY;
  double _bulletSpeedX;
  double _bulletSpeedY;
  double _x, _y;
  EntityState _state;
  double damage;
  double speedfactor;
  double lifetime, _timer;
  int _txtWidth, _txtHeight;

  SpecialBullet(
    this._x,
    this._y,
    double width,
    double height,
    this._bulletSpeedX,
    this._bulletSpeedY,
    String aniPath,
    this._txtWidth,
    this._txtHeight,
  ) {
    final sprshee = SpriteSheet(
        imageName: aniPath,
        textureWidth: _txtWidth,
        textureHeight: _txtHeight,
        columns: 4,
        rows: 1);

    specialBullet = AnimationComponent(
        width, height, sprshee.createAnimation(0, stepTime: 0.1));
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
    return specialBullet.toRect().overlaps(rect);
  }

  Rect toRect() {
    return specialBullet.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();
    specialBullet.x = _x;
    specialBullet.y = _y;
    specialBullet.render(canvas);
    canvas.restore();
  }

  void resize() {
    specialBullet.x = _x;
    specialBullet.y = _y;
    _bulletSpeedX *= speedfactor;
    _bulletSpeedY *= speedfactor;
  }

  void update(double t, List<double> speed) {
    _timer += t;
    setSpeed(speed);

    _x = _x + _bulletSpeedX * speedfactor - t * _speedX * screenSize.width;
    _y = _y + _bulletSpeedY * speedfactor - t * _speedY * screenSize.width;
    if (_timer > lifetime)
      die();
    else
      specialBullet.update(t);
  }

  void setSpeed(List<double> speed) {
    _speedX = speed[0];
    _speedY = speed[1];
  }

  void die() {
    _state = EntityState.Dead;
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
