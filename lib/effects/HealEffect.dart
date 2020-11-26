import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class HealEffect extends Effect {
  Player _player;
  Enemy _enemy;
  HealEffect(this._player, this._enemy)
      : super(EffectType.Heal, 'healEffect.png', _player, _enemy) {
    timer = 0;
    totalDuration = 1;
    final sprShe = SpriteSheet(
        imageName: 'healEffect.png',
        textureWidth: 128,
        textureHeight: 128,
        columns: 4,
        rows: 1);
    final ani = sprShe.createAnimation(0, stepTime: 0.1);
    effect = AnimationComponent(0, 0, ani);
    if (player != null) {
    } else if (enemy != null) {}
  }

  void update(double t, double x, double y) {
    effect.width += t * 90;
    effect.height += t * 45;
    x = x - (effect.width - screenSize.width * 0.06) / 2;
    y = y - (effect.height - screenSize.height * 0.14) / 2;
    if (_player != null) {
      _player.health += t * _player.maxHealth * 0.2;
      if (_player.health > _player.maxHealth)
        _player.health = _player.maxHealth;
    } else if (_enemy != null) {
      _enemy.health += t * _enemy.maxHealth * 0.2;
      if (_enemy.health > _enemy.maxHealth) _enemy.health = _enemy.maxHealth;
    }

    super.update(t, x, y);
  }
}
