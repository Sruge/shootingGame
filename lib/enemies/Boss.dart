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
  double health;
  EntityState state;
  AnimationComponent entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;

  double _specialAttackInterval;
  Boss() : super('boss.png') {
    health = 30;
    maxHealth = 30;
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    attackRange = 200;
    attackInterval = 2;
    bulletTypes = [BulletType.Purple, BulletType.Fire, BulletType.Freeze];

    final spritesheet = SpriteSheet(
        imageName: 'boss.png',
        textureWidth: 32,
        textureHeight: 48,
        columns: 4,
        rows: 4);
    final animation = spritesheet.createAnimation(1, stepTime: 0.1);
    entity = AnimationComponent(0, 0, animation);
    attackRange = 150;
    attackInterval = 4;
    enemySpeedFactor = 0.03;
    _disappearTimer = 0;
    _specialAttackTimer = 0;
    _specialAttackInterval = 3;
    random = Random();
  }

  @override
  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.One, bulletLifetimeFctr, dmgFctr);
    return bullet;
  }

  @override
  void getHit(Bullet bullet) {
    health -= bullet.damage;
    if (health < 1) {
      state = EntityState.Dead;
    }
  }

  @override
  void update(double t, List<double> speed) {
    _disappearTimer += t;
    _specialAttackTimer += t;
    if (_specialAttackTimer > _specialAttackInterval) {
      specialBullets.add(getSpecialAttack());
      _specialAttackTimer = 0;
    }
    if (_disappearTimer > 10) {
      Random random = Random();
      x = random.nextDouble() * screenSize.width;
      y = random.nextDouble() * screenSize.height;
      _disappearTimer = 0;
    } else {
      super.update(t, speed);
    }
  }

  int getScore() {
    return 3;
  }
}
