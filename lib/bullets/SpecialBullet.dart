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

    specialBullet = AnimationComponent(
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
    return specialBullet.toRect().overlaps(rect);
  }

  Rect toRect() {
    return specialBullet.toRect();
  }

  void render(Canvas canvas) {
    canvas.save();
    specialBullet.x = x;
    specialBullet.y = y;
    specialBullet.render(canvas);
    canvas.restore();
  }

  void resize() {
    specialBullet.x = x;
    specialBullet.y = y;
  }

  void update(double t, List<double> speed) {
    _timer += t;
    setSpeed(speed);
    specialBullet.update(t);
    specialBullet.x = x;
    specialBullet.y = y;
    x = specialBullet.x + bulletSpeedX - t * _speedX * screenSize.width;
    y = specialBullet.y + bulletSpeedY - t * _speedY * screenSize.width;

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

  void hitPlayer(Player player) {}

  void hitEnemy(Enemy enemy) {}
}