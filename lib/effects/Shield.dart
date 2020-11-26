import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

class Shield extends Effect {
  Player _player;
  Enemy _enemy;
  StoryHandler _storyHandler;
  Shield(this._player, this._enemy, this._storyHandler)
      : super(EffectType.Heal, 'shield2.png', _player, _enemy) {
    timer = 0;
    totalDuration = 6;
    final sprShe = SpriteSheet(
        imageName: 'shield2.png',
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
    effect.width += t * 60;
    effect.height += t * 30;
    x = x - (effect.width - screenSize.width * 0.06) / 2;
    y = y - (effect.height - screenSize.height * 0.14) / 2;

    //if its an effect on the player
    if (_player != null) {
      _player.health += t * _player.maxHealth * 0.2;
      if (_player.health > _player.maxHealth)
        _player.health = _player.maxHealth;
      _storyHandler.enemies.forEach((enemy) {
        if (enemy.overlaps(effect.toRect())) {
          enemy.health -= t;
        }
      });
      _storyHandler.bullets.forEach((bullet) {
        if (bullet.overlaps(effect.toRect())) {
          bullet.die();
        }
      });

      //if its an effect on an enemy
    } else if (_enemy != null) {
      _enemy.health += t * _enemy.maxHealth * 0.2;
      if (_enemy.health > _enemy.maxHealth) _enemy.health = _enemy.maxHealth;

      if (_player.toRect().overlaps(effect.toRect())) {
        _player.health -= t;
      }
      _player.bullets.forEach((bullet) {
        if (bullet.overlaps(effect.toRect())) {
          bullet.die();
        }
      });
    }

    super.update(t, x, y);
  }
}
