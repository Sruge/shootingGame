import 'dart:math';
import 'dart:ui';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';
import '../EnemyType.dart';

class Altima extends Enemy {
  EnemyType type;
  double _disappearTimer;
  double health;
  EntityState state;
  WalkingEntity entity;
  List<SpecialBullet> specialBullets;
  List<BulletType> bulletTypes;
  Random random;
  double _specialAttackTimer;
  double bulletSpeedFactor;
  double _power;
  StoryHandler _storyHandler;

  double _specialAttackInterval;
  Altima(this._power, this._storyHandler) : super() {
    type = EnemyType.Boss;
    specialBullets = List.empty(growable: true);
    state = EntityState.Normal;

    health = 600;
    maxHealth = 6000;

    attackRange = 200;
    attackInterval = 1;
    bulletTypes = [BulletType.Purple];

    enemySpeedFactor = 0.2;
    _disappearTimer = 0;
    _specialAttackTimer = 0;
    _specialAttackInterval = 3;
    bulletSpeedFactor = 1.5;
    dmgFctr = 1;
    bulletLifetimeFctr = 1;
    entity = WalkingEntity(
        'altima2', 48, 48, Size(baseAnimationWidth, baseAnimationHeight));
    random = Random();
  }

  BasicBullet getAttack() {
    List<double> coords = super.getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        BulletType.Two, bulletLifetimeFctr, dmgFctr, bulletSpeedFactor);
    return bullet;
  }

  SpecialBullet getSpecialAttack() {
    int rand = random.nextInt(bulletTypes.length);
    List<double> coords = getAttackingCoordinates();

    return FreezeBullet(coords[0], coords[1], coords[2], coords[3], _power);
  }

  void getCalledToTheBattlefield() {
    _storyHandler.levelUpdateble = false;
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

  void die() {
    _storyHandler.levelUpdateble = true;
    state = EntityState.Dead;
  }
}
