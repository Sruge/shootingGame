import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/GoldenBullet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectState.dart';
import 'package:shootinggame/enemies/EnemyHealthbar.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';

import 'package:shootinggame/screens/player/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import '../bullets/Bullet.dart';
import '../effects/EffectType.dart';
import '../bullets/FireBullet.dart';
import '../bullets/FreezeBullet.dart';
import '../bullets/PurpleBullet.dart';
import '../bullets/SmokeBullet.dart';

class Enemy {
  double _timer;
  double attackInterval;
  double _distanceToCenter;
  double attackRange;
  double x;
  double y;
  double health;
  double maxHealth;
  double enemySpeedY;
  double enemySpeedX;
  double enemySpeedFactor;
  EnemyhealthBar enemyhealthBar;
  List<SpecialBullet> specialBullets;
  WalkingEntity entity;
  EntityState state;
  List<Effect> effects;
  Random random;
  List<BulletType> bulletTypes;
  double bulletLifetimeFctr;
  double dmgFctr;

  Enemy() {
    _timer = 0;
    state = EntityState.Normal;
    enemySpeedX = 0;
    enemySpeedY = 0;
    enemySpeedFactor = 0.05;
    enemyhealthBar = EnemyhealthBar(0, 0);
    specialBullets = List.empty(growable: true);
    random = Random();
    bulletTypes = List.empty(growable: true);
    effects = List.empty(growable: true);
    bulletLifetimeFctr = 1;
    dmgFctr = 1;
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

  Bullet getAttack() {
    List<double> coords = getAttackingCoordinates();
    Bullet bullet = Bullet(coords[0], coords[1], coords[2], coords[3], 2);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    List<double> coords = getAttackingCoordinates();
    int rand = random.nextInt(bulletTypes.length);
    switch (bulletTypes[rand]) {
      case BulletType.Freeze:
        return FreezeBullet(coords[0], coords[1], coords[2], coords[3]);
      case BulletType.Fire:
        return FireBullet(coords[0], coords[1], coords[2], coords[3]);
      case BulletType.Purple:
        return PurpleBullet(coords[0], coords[1], coords[2], coords[3]);
      case BulletType.Smoke:
        return SmokeBullet(coords[0], coords[1], coords[2], coords[3]);
      case BulletType.Gold:
        return GoldenBullet(coords[0], coords[1], coords[2], coords[3]);
        break;
      default:
        PurpleBullet(coords[0], coords[1], coords[2], coords[3]);
        break;
    }
  }

  bool isDead() {
    return state == EntityState.Dead;
  }

  void getHit(Bullet bullet) {
    health -= bullet.damage;
    if (health <= 0) state = EntityState.Dead;
  }

  void onTapDown(TapDownDetails detail, Function fn) {}

  bool contains(Offset offset) {
    return entity.toRect().contains(offset);
  }

  bool overlaps(Rect rect) {
    return entity.toRect().overlaps(rect);
  }

  void render(Canvas canvas) {
    entity.render(canvas);
    canvas.save();
    enemyhealthBar.render(canvas);
    canvas.restore();
    effects.forEach((effect) {
      canvas.save();
      effect.render(canvas);
      canvas.restore();
    });
  }

  void resize() {
    entity.resize();

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
    enemyhealthBar.resize(x, y);
    effects.forEach((effect) {
      effect.resize(x, y);
    });
  }

  void update(double t, List<double> bgSpeed) {
    _timer += t;
    double sumDistance;
    sumDistance =
        (x - screenSize.width / 2).abs() + (y - screenSize.height / 2).abs();
    var distanceToCenter = getDistanceToCenter();
    enemySpeedX =
        -(x - screenSize.width * 0.94 / 2) / sumDistance * enemySpeedFactor;
    enemySpeedY =
        -(y - screenSize.height * 0.86 / 2) / sumDistance * enemySpeedFactor;
    if (distanceToCenter < attackRange - 10) {
      enemySpeedX = 0;
      enemySpeedY = 0;
    }

    x = x +
        0.04 * enemySpeedX * screenSize.width -
        t * bgSpeed[0] * screenSize.width;
    y = y +
        0.04 * enemySpeedY * screenSize.width -
        t * bgSpeed[1] * screenSize.width;

    enemyhealthBar.updateRect(maxHealth, health, x, y);
    effects.forEach((effect) {
      effect.update(t, x, y);
    });
    effects.removeWhere((element) => element.state == EffectState.Ended);
    entity.x = x;
    entity.y = y;
    entity.update(t, [enemySpeedX, enemySpeedY]);
    if (health <= 0) state = EntityState.Dead;
  }

  double getDistanceToCenter() {
    _distanceToCenter = sqrt(pow((x - screenSize.width * 0.94 / 2).abs(), 2) +
        pow((y - screenSize.height * 0.86 / 2).abs(), 2));
    return _distanceToCenter;
  }

  int getScore() {
    return 1;
  }
}
