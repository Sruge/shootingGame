import 'dart:math';
import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FireBullet.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/bullets/SmokeBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../../bullets/Bullet.dart';
import '../EnemyType.dart';

class Boss extends Enemy {
  double _bossTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  AnimationComponent _beaming;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;
  double _power;
  double _nextBeamTime;
  bool _beamingNow;
  double _beamingTimer;
  StoryHandler _storyHandler;
  double _beamingDuration;
  double _initialSpeedFactor;
  EnemyType type;

  double _nextSpecialAttack;
  Boss(this._power) : super() {
    type = EnemyType.Boss;
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;
    _bossTimer = 0;
    _specialAttackTimer = 0;
    _beamingNow = false;

    bulletTypes = [
      BulletType.Fire,
    ];
    health = 3000;
    maxHealth = 3000;
    attackRange = 150;
    attackInterval = 2.5;
    _nextSpecialAttack = 2.25;
    _initialSpeedFactor = 0.15;
    enemySpeedFactor = _initialSpeedFactor;
    bulletSpeedFactor = 1;
    dmgFctr = 1;
    _nextBeamTime = 15;
    bulletLifetimeFctr = 1;
    _beamingDuration = 1;

    entity = WalkingEntity(
        'boss', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));

    final sprShe = SpriteSheet(
        imageName: 'bossbeaming.png',
        textureWidth: 32,
        textureHeight: 48,
        columns: 4,
        rows: 1);
    _beaming =
        AnimationComponent(32, 38, sprShe.createAnimation(0, stepTime: 0.1));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Three, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    int rand = random.nextInt(3);
    List<double> coords = getAttackingCoordinates();
    if (rand < 1) {
      return FreezeBullet(coords[0], coords[1], coords[2], coords[3], _power);
    } else if (rand < 2) {
      return FireBullet(coords[0], coords[1], coords[2], coords[3], _power);
    } else {
      return SmokeBullet(
          coords[0], coords[1], coords[2], coords[3], _power * 3);
    }
  }

  void resize() {
    _beaming.width = screenSize.width * 0.06;
    _beaming.height = screenSize.height * 0.14;
    super.resize();
  }

  @override
  void update(double t, List<double> speed) {
    _bossTimer += t;

    if (_bossTimer > _nextSpecialAttack) {
      specialBullets.add(getSpecialAttack());
      _nextSpecialAttack = _bossTimer + random.nextDouble() * 8;
    }

    if (_beamingNow) {
      enemySpeedFactor = 0;
    }
    if (_bossTimer > _nextBeamTime && !_beamingNow) {
      _beamingNow = true;
      entity.overwriteActiveEntity(_beaming);
    }
    if (_bossTimer > _nextBeamTime + _beamingDuration && _beamingNow) {
      _beamingNow = false;
      enemySpeedFactor = _initialSpeedFactor;
      entity.reset();
      _nextBeamTime = _bossTimer + 15;

      Random random = Random();
      Offset bgPos = screenManager.getBgPos();
      x = random.nextDouble() * screenSize.width * 2 + bgPos.dx;
      y = random.nextDouble() * screenSize.height * 2 + bgPos.dx;
    }
    super.update(t, speed);
  }

  int getScore() {
    return 3;
  }

  void die() {
    _storyHandler.levelUpdateble = true;
    super.die();
  }
}
