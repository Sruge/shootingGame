import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'EffectState.dart';

class FreezeEffect extends Effect {
  double _initialSpeed;
  Player _player;
  Enemy _enemy;
  double _power;
  FreezeEffect(this._player, this._enemy, this._power)
      : super(EffectType.Freeze, 'freezeTrans.png', _player, _enemy) {
    timer = 0;
    totalDuration = 1.5 * _power;
    if (player != null) {
      _initialSpeed = player.speedfactor;
      //screenManager.setSpeedfactor(0, true);
      _player.frozen = true;
    } else if (enemy != null) {
      _initialSpeed = enemy.enemySpeedFactor;
      enemy.frozen = true;
    }
  }

  void update(double t, double x, double y) {
    timer += t;
    if (timer > totalDuration) {
      if (_player != null) {
        _player.frozen = false;
        //screenManager.setSpeedfactor(0.2, true);
        state = EffectState.Ended;
      } else if (_enemy != null) {
        _enemy.frozen = false;
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
