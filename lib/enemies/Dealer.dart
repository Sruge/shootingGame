import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/enemies/BasicBullet.dart';
import 'package:shootinggame/enemies/BulletType.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/FriendType.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';

import 'Bullet.dart';
import 'FreezeBullet.dart';
import 'Friend.dart';

class Dealer extends Friend {
  AnimationComponent entity;
  String aniPath;
  Dealer() : super(FriendType.Dealer) {
    attackRange = 130;
    attackInterval = 3;
    health = 4;
    maxHealth = 4;

    switch (type) {
      case FriendType.Dealer:
        attackRange = 200;
        attackInterval = 3;
        break;
      case FriendType.Healer:
        attackRange = 120;
        attackInterval = 5;
        break;
      default:
        attackRange = 120;
        attackInterval = 5;
        break;
    }
    final spritesheet = SpriteSheet(
        imageName: 'dealer.png',
        textureWidth: 32,
        textureHeight: 48,
        columns: 4,
        rows: 4);
    final animation = spritesheet.createAnimation(1, stepTime: 0.1);
    entity = AnimationComponent(0, 0, animation);
  }

  @override
  EffectType getEffect() {
    if (type == FriendType.Dealer)
      return EffectType.Deal;
    else
      return EffectType.None;
  }

  @override
  void trigger() {
    screenManager.showDeal(x, y);
  }
}
