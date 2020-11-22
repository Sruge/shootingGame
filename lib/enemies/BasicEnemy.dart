import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/enemies/BasicBullet.dart';
import 'package:shootinggame/enemies/BulletType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';

import 'Bullet.dart';
import 'FreezeBullet.dart';

class BasicEnemy extends Enemy {
  EnemyType _type;
  AnimationComponent entity;
  BulletType _bulletType;
  String aniPath;
  BasicEnemy(this._type) : super('priest.png') {
    attackRange = 130;
    attackInterval = 3;
    health = 4;
    maxHealth = 4;

    switch (_type) {
      case EnemyType.One:
        aniPath = 'priest.png';
        attackRange = 200;
        attackInterval = 3;
        break;
      case EnemyType.Two:
        aniPath = 'monster.png';
        attackRange = 50;
        attackInterval = 5;
        break;
      default:
        aniPath = 'monster.png';
        break;
    }
    final spritesheet = SpriteSheet(
        imageName: aniPath,
        textureWidth: 32,
        textureHeight: 48,
        columns: 4,
        rows: 4);
    final animation = spritesheet.createAnimation(1, stepTime: 0.1);
    entity = AnimationComponent(0, 0, animation);
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
