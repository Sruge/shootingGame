import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shootinggame/enemies/EffectType.dart';

import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class SpecialBullet {
  AnimationComponent _specialBullet;
  double _speedX;
  double _speedY;
  double bulletSpeedX;
  double bulletSpeedY;
  double x, y;
  EntityState _state;
  double damage;
  double speedfactor;
  double lifetime, _timer;

  SpecialBullet(double x, double y, double width, double height, bulletSpeedX,
      bulletSpeedY, String aniPath, this.speedfactor) {
    final sprshee = SpriteSheet(
        imageName: aniPath,
        textureWidth: 32,
        textureHeight: 32,
        columns: 4,
        rows: 1);

    _specialBullet = AnimationComponent(
        width, height, sprshee.createAnimation(0, stepTime: 0.1));
    _state = EntityState.Normal;
    setSpeed([0, 0]);
    damage = 1;
    _timer = 0;
    lifetime = 1;

    this.x = x;
    this.y = y;
    this.bulletSpeedX =
        bulletSpeedX * speedfactor / (bulletSpeedX.abs() + bulletSpeedY.abs());
    this.bulletSpeedY =
        bulletSpeedY * speedfactor / (bulletSpeedX.abs() + bulletSpeedY.abs());
  }

  bool isDead() {
    return _state == EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  bool overlaps(Rect rect) {
    return _specialBullet.toRect().overlaps(rect);
  }

  Rect toRect() {
    return _specialBullet.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();
    _specialBullet.x = x;
    _specialBullet.y = y;
    _specialBullet.render(canvas);
    canvas.restore();
  }

  void resize() {
    _specialBullet.x = x;
    _specialBullet.y = y;
  }

  void update(double t, List<double> speed) {
    _timer += t;
    setSpeed(speed);
    _specialBullet.update(t);
    _specialBullet.x = x;
    _specialBullet.y = y;
    x = _specialBullet.x + bulletSpeedX - t * _speedX * screenSize.width;
    y = _specialBullet.y + bulletSpeedY - t * _speedY * screenSize.width;

    if (_timer > lifetime) die();

    if (x < 0 || x > screenSize.width * 3 || y < 0 || y > screenSize.height * 2)
      die();
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
