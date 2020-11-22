import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/enemies/BulletType.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/enemies/EnemyHealthbar.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/SpecialBullet.dart';
import 'package:shootinggame/entities/AssetsSizes.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/player/Healthbar.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'Bullet.dart';
import 'FriendType.dart';

class Friend {
  double _timer;
  double attackInterval;
  List<Bullet> _bullets;
  AnimationComponent entity;
  EntityState _state;
  double _distanceToCenter;
  double attackRange;
  bool _flipRender;
  double x;
  double y;
  double health;
  double maxHealth;
  FriendType type;
  BulletType _bulletType;

  List<Sprite> _sprites = List<Sprite>();
  int leftOrDown;
  double enemySpeedY;

  double enemySpeedX;
  double enemySpeedFactor;
  EnemyhealthBar _enemyhealthBar;
  List<SpecialBullet> specialBullets;

  Friend(this.type) {
    _timer = 0;
    _bullets = List.empty(growable: true);
    _state = EntityState.Normal;
    _flipRender = false;
    enemySpeedX = 0;
    enemySpeedY = 0;
    enemySpeedFactor = 0.05;
    specialBullets = List.empty(growable: true);
    Random random = Random();
    leftOrDown = random.nextInt(2);
  }

  bool attacks() {
    if (_timer >= attackInterval && getDistanceToCenter() < attackRange) {
      _timer = 0;
      return true;
    } else {
      return false;
    }
  }

  List<double> getAttackingCoordinates() {
    double sumDistance = (entity.x - screenSize.width * 0.94 / 2).abs() +
        (entity.y - screenSize.height * 0.86 / 2).abs();
    double bulletSpeedX =
        -(entity.x - screenSize.width * 0.94 / 2) / sumDistance;
    double bulletSpeedY =
        -(entity.y - screenSize.height * 0.86 / 2) / sumDistance;
    List<double> coords = [
      entity.x + 15,
      entity.y + 30,
      bulletSpeedX,
      bulletSpeedY
    ];

    return coords;
  }

  EffectType getEffect() {
    return EffectType.None;
  }

  SpecialBullet getSpecialAttack() {
    return null;
  }

  bool isDead() {
    return _state == EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Function fn) {}

  bool contains(Offset offset) {
    return entity.toRect().contains(offset);
  }

  bool overlaps(Rect rect) {
    return entity.toRect().overlaps(rect);
  }

  void render(Canvas canvas) {
    if (_flipRender) {
      entity.renderFlipX = true;
    } else {
      entity.renderFlipX = false;
    }
    entity.x = x;
    entity.y = y;
    canvas.save();
    entity.render(canvas);
    canvas.restore();
  }

  void resize() {
    entity.width = screenSize.width * 0.06;
    entity.height = screenSize.height * 0.14;

    int spawnUpDownLeftRight = Random().nextInt(4);
    double spawnPos = Random().nextDouble();
    switch (spawnUpDownLeftRight) {
      case 0:
        x = screenSize.width * spawnPos;
        y = -80;
        break;
      case 1:
        x = screenSize.width + 50;
        y = screenSize.height * spawnPos;
        break;
      case 2:
        x = screenSize.width * spawnPos;
        y = screenSize.height + 50;
        break;
      case 3:
        x = -80;
        y = screenSize.height * spawnPos;
        break;
    }
  }

  void update(double t, List<double> bgSpeed) {
    _timer += t;

    if (leftOrDown < 1)
      enemySpeedX = 0.05;
    else
      enemySpeedY = 0.05;

    if (enemySpeedX < 0) {
      _flipRender = false;
    } else if (enemySpeedX > 0) {
      _flipRender = true;
    }

    x = x +
        0.04 * enemySpeedX * screenSize.width -
        t * bgSpeed[0] * screenSize.width;
    y = y +
        0.04 * enemySpeedY * screenSize.width -
        t * bgSpeed[1] * screenSize.width;

    entity.animation.update(t);
  }

  double getDistanceToCenter() {
    _distanceToCenter = sqrt(pow((x - screenSize.width * 0.94 / 2).abs(), 2) +
        pow((y - screenSize.height * 0.86 / 2).abs(), 2));
    return _distanceToCenter;
  }

  void die() {
    _state = EntityState.Dead;
  }

  void trigger() {}
}
