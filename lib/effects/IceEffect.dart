import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class IceEffect extends Effect {
  Player _player;
  Enemy _enemy;
  IceEffect(this._player, this._enemy)
      : super(EffectType.Ice, 'ice.png', _player, _enemy) {
    timer = 0;
    totalDuration = 5;
    final sprShe = SpriteSheet(
        imageName: 'ice.png',
        textureWidth: 256,
        textureHeight: 256,
        columns: 4,
        rows: 1);
    final ani = sprShe.createAnimation(0, stepTime: 0.1);
    effect = AnimationComponent(0, 0, ani);
    if (player != null) {
    } else if (enemy != null) {}
  }

  void update(double t, double x, double y) {
    super.update(t, 0, 0);
  }

  void resize(double x, double y) {
    if (renderSomething) {
      effect.x = 0;
      effect.y = 0;
      effect.width = screenSize.width;
      effect.height = screenSize.height;
    }
  }
}
