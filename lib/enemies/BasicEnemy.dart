import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/screens/player/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class BasicEnemy extends Enemy {
  EnemyType _type;
  WalkingEntity entity;
  BulletType _bulletType;
  String aniPath;
  int _txtWidth, _txtHeight;
  double _attackRange,
      _attackInterval,
      _bulletLifetime,
      _dmgMultiplier,
      _healtMulti,
      _enemySpeed;
  BasicEnemy(
      this._type,
      this._dmgMultiplier,
      this._attackRange,
      this._attackInterval,
      this._bulletLifetime,
      this._healtMulti,
      this._enemySpeed)
      : super() {
    attackRange = 130;
    attackInterval = 3;
    health = 4;
    maxHealth = 4;

    switch (_type) {
      case EnemyType.One:
        aniPath = 'priest.png';
        attackRange = 200 * _attackRange;
        attackInterval = 2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        dmgFctr = 1 * _dmgMultiplier;
        _bulletType = BulletType.One;
        maxHealth = 4 * _healtMulti;
        _txtWidth = 32;
        _txtHeight = 48;
        break;
      case EnemyType.Two:
        aniPath = 'monster.png';
        attackRange = 200 * _attackRange;
        attackInterval = 2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        dmgFctr = 1 * _dmgMultiplier;
        _bulletType = BulletType.One;
        maxHealth = 4 * _healtMulti;
        _txtWidth = 32;
        _txtHeight = 48;
        break;
      case EnemyType.Three:
        aniPath = 'angel.png';
        attackRange = 200 * _attackRange;
        attackInterval = 2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        dmgFctr = 1 * _dmgMultiplier;
        _bulletType = BulletType.Two;
        maxHealth = 4 * _healtMulti;
        _txtWidth = 48;
        _txtHeight = 48;
        break;
      case EnemyType.Four:
        aniPath = 'ryuk.png';
        attackRange = 200 * _attackRange;
        attackInterval = 2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        dmgFctr = 1 * _dmgMultiplier;
        _bulletType = BulletType.Two;
        maxHealth = 4 * _healtMulti;
        _txtWidth = 48;
        _txtHeight = 64;
        break;
      case EnemyType.Five:
        aniPath = 'ray.png';
        attackRange = 200 * _attackRange;
        attackInterval = 2 * _attackInterval;
        bulletLifetimeFctr = 2 * _bulletLifetime;
        dmgFctr = 1 * _dmgMultiplier;
        _bulletType = BulletType.Three;
        maxHealth = 4 * _healtMulti;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      default:
        aniPath = 'monster.png';
    }
    entity = WalkingEntity(aniPath, _txtWidth, _txtHeight,
        Size(baseAnimationWidth, baseAnimationHeight));
  }

  @override
  BasicBullet getAttack() {
    List<double> coords = getAttackingCoordinates();
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        _bulletType, bulletLifetimeFctr, dmgFctr);

    return bullet;
  }
}
