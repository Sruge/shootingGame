import 'dart:math';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/rendering.dart';
import 'package:shootinggame/enemies/BasicBullet.dart';
import 'package:shootinggame/enemies/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/FireBullet.dart';
import 'package:shootinggame/enemies/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'Bullet.dart';
import 'FreezeBullet.dart';

class Boss extends Enemy {
  double _disappearTimer;
  EnemyType _type;
  double health;
  EntityState _entityState;
  AnimationComponent entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> _bulletTypes;
  Random random;
  Boss(this._type) : super(EnemyType.Three, 'boss.png') {
    health = 30;
    maxHealth = 30;
    specialBullets = List.empty(growable: true);
    _entityState = EntityState.Normal;
    attackRange = 200;
    attackInterval = 2;
    _bulletTypes = [BulletType.Freeze, BulletType.Fire];

    final spritesheet = SpriteSheet(
        imageName: 'boss.png',
        textureWidth: 32,
        textureHeight: 48,
        columns: 4,
        rows: 4);
    final animation = spritesheet.createAnimation(1, stepTime: 0.1);
    entity = AnimationComponent(0, 0, animation);
    attackRange = 200;
    attackInterval = 4;
    enemySpeedFactor = 0.1;
    _disappearTimer = 0;
    random = Random();
  }

  @override
  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet =
        BasicBullet(coords[0], coords[1], coords[2], coords[3], BulletType.One);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    List<double> coords = super.getAttackingCoordinates();
    int rand = random.nextInt(_bulletTypes.length);
    switch (_bulletTypes[rand]) {
      case BulletType.Freeze:
        return FreezeBullet(coords[0], coords[1], coords[2], coords[3]);
      case BulletType.Fire:
        return FireBullet(coords[0], coords[1], coords[2], coords[3]);
      case BulletType.One:
        break;
      case BulletType.Two:
        break;
      default:
        break;
    }
  }

  @override
  void getHit(Bullet bullet) {
    health -= bullet.damage;
    if (health < 1) {
      _entityState = EntityState.Dead;
    }
  }

  @override
  void update(double t, List<double> speed) {
    _disappearTimer += t;
    if (_disappearTimer > 10) {
      Random random = Random();
      x = random.nextDouble() * screenSize.width;
      y = random.nextDouble() * screenSize.height;
      specialBullets.add(getSpecialAttack());
      _disappearTimer = 0;
    } else {
      super.update(t, speed);
    }
  }

  bool isDead() {
    return _entityState == EntityState.Dead;
  }
}
