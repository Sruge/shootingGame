import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';

import 'DealerBord.dart';
import 'Friend.dart';
import 'FriendType.dart';

class Dealer extends Friend {
  AnimationComponent entity;
  String aniPath;
  DealerBord _dealerBord;
  Dealer() : super(FriendType.Dealer) {
    attackRange = 130;
    attackInterval = 3;
    health = 4;
    maxHealth = 4;
    _dealerBord = DealerBord(true);

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
    return EffectType.Deal;
  }

  @override
  void trigger() {
    screenManager.showDeal(x, y, _dealerBord);
  }
}
