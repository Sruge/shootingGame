import 'dart:ui';

import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class BasicEnemy extends Enemy {
  EnemyType type;
  WalkingEntity entity;
  BulletType _bulletType;
  String aniPath;
  int _txtWidth, _txtHeight;
  double _attackRange,
      _attackInterval,
      _bulletLifetime,
      _dmgMultiplier,
      _healtMulti,
      _enemySpeed,
      _bulletSpeed;
  BasicEnemy(
      this.type,
      this._dmgMultiplier,
      this._attackRange,
      this._attackInterval,
      this._bulletLifetime,
      this._healtMulti,
      this._enemySpeed,
      this._bulletSpeed)
      : super() {
    switch (type) {
      case EnemyType.One:
        aniPath = 'priest';
        attackRange = 200 * _attackRange;
        attackInterval = 2.5 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.One;
        maxHealth = 20 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 48;
        break;
      case EnemyType.Two:
        aniPath = 'monster';
        attackRange = 150 * _attackRange;
        attackInterval = 2.5 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.One;
        maxHealth = 30 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 48;
        break;
      case EnemyType.Three:
        aniPath = 'angel';
        attackRange = 130 * _attackRange;
        attackInterval = 1.8 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.One;
        maxHealth = 40 * _healtMulti;
        health = maxHealth;
        _txtWidth = 48;
        _txtHeight = 48;
        break;
      case EnemyType.Four:
        aniPath = 'ryuk';
        attackRange = 250 * _attackRange;
        attackInterval = 2.5 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.Two;
        maxHealth = 70 * _healtMulti;
        health = maxHealth;
        _txtWidth = 48;
        _txtHeight = 64;
        break;
      case EnemyType.Five:
        aniPath = 'ray';
        attackRange = 100 * _attackRange;
        attackInterval = 2.2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.Two;
        maxHealth = 200 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      case EnemyType.Six:
        aniPath = 'bunte';
        attackRange = 180 * _attackRange;
        attackInterval = 4 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.Three;
        maxHealth = 200 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      case EnemyType.PirateOne:
        aniPath = 'pirate1';
        attackRange = 50 * _attackRange;
        attackInterval = 2.5 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.Three;
        maxHealth = 200 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      case EnemyType.PirateTwo:
        aniPath = 'pirate2';
        attackRange = 100 * _attackRange;
        attackInterval = 2.2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.Three;
        maxHealth = 200 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      case EnemyType.PirateThree:
        aniPath = 'pirate3';
        attackRange = 150 * _attackRange;
        attackInterval = 1.9 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        _bulletType = BulletType.Three;
        maxHealth = 200 * _healtMulti;
        health = maxHealth;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      default:
        aniPath = 'monster';
    }
    dmgFctr = _dmgMultiplier;
    enemySpeedFactor = _enemySpeed;
    bulletSpeedFactor = _bulletSpeed;
    entity = WalkingEntity(aniPath, _txtWidth, _txtHeight,
        Size(baseAnimationWidth, baseAnimationHeight));
  }

  BasicBullet getAttack() {
    List<double> coords = getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        _bulletType, bulletLifetimeFctr, dmgFctr, _bulletSpeed);

    return bullet;
  }
}
