import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'EffectState.dart';

class FireEffect extends Effect {
  Player _player;
  Enemy _enemy;
  FireEffect(this._player, this._enemy)
      : super(EffectType.Gold, 'fire.png', _player, _enemy) {
    timer = 0;
    totalDuration = 4;
    renderSomething = true;
  }

  void update(t, x, y) {
    timer += t;
    if (timer > totalDuration) {
      if (_player != null) {
        _player.health -= 3;
        if (_player.health <= 0) {
          _player.die();
        }
        state = EffectState.Ended;
      } else if (_enemy != null) {
        _enemy.health -= 3;
        if (_enemy.health <= 0) {
          _enemy.state = EntityState.Dead;
        }
        state = EffectState.Ended;
      }
    }
    if (renderSomething) {
      effect.x = x;
      effect.y = y;
      effect.update(t);
    }
  }
}
