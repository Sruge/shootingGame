import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Friend {
  double _timer;
  double attackInterval;
  WalkingEntity entity;
  EntityState state;
  double _distanceToCenter;
  double attackRange;
  bool flipRender;
  double x;
  double y;
  double health;
  double maxHealth;
  List<SpecialBullet> bullets;

  int leftOrDown;
  double enemySpeedY;

  double enemySpeedX;
  double enemySpeedFactor;
  List<SpecialBullet> specialBullets;
  Random random;

  Friend() {
    _timer = 0;
    state = EntityState.Normal;
    flipRender = false;
    enemySpeedX = 0;
    enemySpeedY = 0;
    enemySpeedFactor = 0.2;
    specialBullets = List.empty(growable: true);
    random = Random();
    leftOrDown = random.nextInt(2);
    bullets = [];
  }

  bool attacks() {
    if (_timer >= attackInterval && getDistanceToCenter() < attackRange) {
      _timer = 0;
      return true;
    } else {
      return false;
    }
  }

  void update(double t, List<double> speed) {}

  List<double> getAttackingCoordinates(
      double x, double y, double width, double height) {
    final entityCenterX = x + width / 2;
    final entityCenterY = y + height / 2;

    double sumDistance = (entityCenterX - screenSize.width / 2).abs() +
        (entityCenterY - screenSize.height / 2).abs();
    double bulletSpeedX = -(entityCenterX - screenSize.width / 2) / sumDistance;
    double bulletSpeedY =
        -(entityCenterY - screenSize.height / 2) / sumDistance;
    List<double> coords = [
      entityCenterX,
      entityCenterY,
      bulletSpeedX,
      bulletSpeedY
    ];

    return coords;
  }

  SpecialBullet getSpecialAttack() {
    return null;
  }

  bool isDead() {
    return state == EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Player player) {}

  bool contains(Offset offset) {
    return entity.toRect().contains(offset);
  }

  bool overlaps(Rect rect) {
    return entity.toRect().overlaps(rect);
  }

  void render(Canvas canvas) {
    // if (flipRender) {
    //   entity.renderFlipX = true;
    // } else {
    //   entity.renderFlipX = false;
    // }
    entity.x = x;
    entity.y = y;
    canvas.save();
    entity.render(canvas);
    canvas.restore();
  }

  void resize() {
    entity.resize();

    Offset bgPos = screenManager.getBgPos();
    x = (bgPos.dx + screenSize.width * 2) * random.nextDouble();
    y = (bgPos.dy + screenSize.height * 2) * random.nextDouble();
  }

  double getDistanceToCenter() {
    _distanceToCenter = sqrt(pow((x - screenSize.width / 2).abs(), 2) +
        pow((y - screenSize.height / 2).abs(), 2));
    return _distanceToCenter;
  }

  void die() {
    state = EntityState.Dead;
  }

  void trigger() {}
}
