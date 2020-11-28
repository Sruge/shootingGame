import 'package:flame/components/component.dart';

import 'Bullet.dart';
import 'BulletType.dart';

class BasicBullet extends Bullet {
  double damage;
  BulletType _type;
  BasicBullet(double x, double y, double _bulletSpeedX, double _bulletSpeedY,
      this._type, double lifetimeFctr, double damageFctr, double bulletSpeed)
      : super(x, y, _bulletSpeedX, _bulletSpeedY) {
    if (_type == BulletType.One) {
      damage = damageFctr * 20.0;
      lifetime = lifetimeFctr;
      speedfactor = bulletSpeed * 3.5;
      bullet = SpriteComponent.square(6, 'bullet.png');
    } else if (_type == BulletType.Two) {
      damage = 40.0 * damageFctr;
      lifetime = 1.1 * lifetimeFctr;
      speedfactor = bulletSpeed * 4.5;
      bullet = SpriteComponent.square(7, 'redBullet.png');
    } else if (_type == BulletType.Three) {
      damage = 60.0 * damageFctr;
      lifetime = 1.2 * lifetimeFctr;
      speedfactor = bulletSpeed * 5;
      bullet = SpriteComponent.square(8, 'greenBullet.png');
    }
  }
}
