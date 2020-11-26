import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Sparkle extends Effect {
  Player _player;
  Enemy _enemy;
  double _initDmg;
  Sparkle(this._player, this._enemy)
      : super(EffectType.Sparkle, 'goldeffekt.png', _player, _enemy) {
    timer = 0;
    totalDuration = 25;
    final sprShe = SpriteSheet(
        imageName: 'goldeffekt.png',
        textureWidth: 64,
        textureHeight: 64,
        columns: 4,
        rows: 1);
    final ani = sprShe.createAnimation(0, stepTime: 0.1);
    effect = AnimationComponent(0, 0, ani);
    if (player != null) {
      _initDmg = _player.dmgFctr;
    } else if (enemy != null) {
      _initDmg = _player.dmgFctr;
    }
  }

  void update(double t, double x, double y) {
    effect.width += t * 6;
    effect.height += t * 6;
    x = x - (effect.width - screenSize.width * 0.06) / 2;
    y = y - (effect.height - screenSize.height * 0.14) / 2;
    if (_player != null) {
      _player.dmgFctr += t * 0.5;
    } else if (_enemy != null) {
      _enemy.dmgFctr += t * 0.5;
    }

    super.update(t, x, y);
  }

  void end() {
    if (_player != null) {
      _player.dmgFctr = _initDmg;
    } else if (_enemy != null) {
      _enemy.dmgFctr = _initDmg;
    }
    super.end();
  }
}
