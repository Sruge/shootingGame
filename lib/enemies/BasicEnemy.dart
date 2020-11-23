import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/bullets/BasicBullet.dart';
import 'package:shootinggame/bullets/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/screens/player/WalkingEntity.dart';

class BasicEnemy extends Enemy {
  EnemyType _type;
  WalkingEntity entity;
  BulletType _bulletType;
  String aniPath;
  int _txtWidth, _txtHeight;
  BasicEnemy(this._type) : super() {
    attackRange = 130;
    attackInterval = 3;
    health = 4;
    maxHealth = 4;

    switch (_type) {
      case EnemyType.One:
        aniPath = 'priest.png';
        attackRange = 200;
        attackInterval = 2;
        bulletLifetimeFctr = 2;
        _txtWidth = 32;
        _txtHeight = 48;
        break;
      case EnemyType.Two:
        aniPath = 'monster.png';
        attackRange = 150;
        attackInterval = 5;
        bulletLifetimeFctr = 1;
        _txtWidth = 32;
        _txtHeight = 48;
        break;
      case EnemyType.Three:
        aniPath = 'angel.png';
        attackRange = 75;
        attackInterval = 4;
        bulletLifetimeFctr = 1;
        _txtWidth = 48;
        _txtHeight = 48;
        break;
      case EnemyType.Four:
        aniPath = 'ryuk.png';
        attackRange = 120;
        attackInterval = 4;
        bulletLifetimeFctr = 1;
        _txtWidth = 48;
        _txtHeight = 64;
        break;
      case EnemyType.Five:
        aniPath = 'ray.png';
        attackRange = 130;
        attackInterval = 3;
        bulletLifetimeFctr = 1;
        _txtWidth = 32;
        _txtHeight = 52;
        break;
      default:
        aniPath = 'monster.png';
    }
    entity = WalkingEntity(aniPath, _txtWidth, _txtHeight);
  }

  @override
  BasicBullet getAttack() {
    List<double> coords = getAttackingCoordinates();
    if (_type == EnemyType.One)
      _bulletType = BulletType.One;
    else if (_type == EnemyType.Two) _bulletType = BulletType.Two;
    BasicBullet bullet = BasicBullet(coords[0], coords[1], coords[2], coords[3],
        _bulletType, bulletLifetimeFctr, dmgFctr);
    return bullet;
  }
}
