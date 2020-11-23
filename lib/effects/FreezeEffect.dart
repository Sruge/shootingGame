import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';

class FreezeEffect extends Effect {
  double _initialSpeed, _timer, _totalDuration;
  Player _player;
  Enemy _enemy;
  FreezeEffect(Player player, Enemy enemy)
      : super(EffectType.Gold, 'freeze.png') {
    _timer = 0;
    _totalDuration = 3;
    if (player != null) {
      _initialSpeed = player.speedfactor;
      screenManager.setSpeedfactor(0, true);
    } else if (enemy != null) {
      _initialSpeed = enemy.enemySpeedFactor;
      enemy.enemySpeedFactor = 0;
    }
  }

  void update(double t, double x, double y) {
    _timer += t;
    if (_timer > _totalDuration) {
      if (_player != null) {
        screenManager.setSpeedfactor(_initialSpeed, true);
      } else if (_enemy != null) {
        _enemy.enemySpeedFactor = _initialSpeed;
      }
      type = EffectType.None;
    }
    super.update(t, x, y);
  }
}
