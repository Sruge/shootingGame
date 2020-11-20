import 'dart:math';
import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/enemies/Bullet.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Fire extends Bullet {
  AnimationComponent _fire;
  Offset _endPoint;
  double _x, _y;
  EntityState _state;
  double damage;
  double _speedX, _speedY;
  double _distanceToCenter;

  Fire(double x, double y, Offset pos) : super(0.0, 0.0, 0.0, 0.0, null, 0) {
    final spritesheet = SpriteSheet(
        imageName: 'fire.png',
        textureWidth: 32,
        textureHeight: 48,
        columns: 8,
        rows: 1);

    final animation = spritesheet.createAnimation(0, stepTime: 0.1);

    _fire = AnimationComponent(50, 10, animation);
    _state = EntityState.Normal;
    damage = 1;

    _x = x;
    _y = y;
    _endPoint = pos;
  }

  bool isDead() {
    return _state == EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  bool overlaps(Rect rect) {
    return _fire.toRect().overlaps(rect);
  }

  Rect toRect() {
    return _fire.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();

    _fire.render(canvas);
    canvas.restore();
  }

  void resize() {
    _fire.x = _x;
    _fire.y = _y;
    _fire.width = getDistanceToCenter(_endPoint);
    _fire.height = 10;

    _fire.resize(Size(_fire.width, 10));
  }

  void update(double t, List<double> speed) {
    _fire.update((t));

    setSpeed(speed);
    _fire.x = _x;
    _fire.y = _y;
    _fire.width = getDistanceToCenter(_endPoint);
    _fire.angle = -160;
    _x = _x - t * _speedX * screenSize.width;
    _y = _y - t * _speedY * screenSize.width;

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

  double getDistanceToCenter(Offset pos) {
    _distanceToCenter = sqrt(
        pow((pos.dx - screenSize.width * 0.88 / 2).abs(), 2) +
            pow((pos.dy - screenSize.height * 0.8 / 2).abs(), 2));
    return _distanceToCenter;
  }
}
