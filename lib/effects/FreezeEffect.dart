import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'EffectState.dart';

class FreezeEffect extends Effect {
  double _initialSpeed;
  Player _player;
  Enemy _enemy;
  FreezeEffect(this._player, this._enemy)
      : super(EffectType.Gold, 'freeze.png', _player, _enemy) {
    timer = 0;
    totalDuration = 1;
    if (player != null) {
      _initialSpeed = player.speedfactor;
      screenManager.setSpeedfactor(0, true);
    } else if (enemy != null) {
      _initialSpeed = enemy.enemySpeedFactor;
      enemy.enemySpeedFactor = 0;
    }
  }

  void update(double t, double x, double y) {
    timer += t;
    if (timer > totalDuration) {
      if (_player != null) {
        screenManager.setSpeedfactor(_initialSpeed, true);
        state = EffectState.Ended;
      } else if (_enemy != null) {
        _enemy.enemySpeedFactor = _initialSpeed;
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
