import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

class FireEffect extends Effect {
  double _timer, _totalDuration;

  Player _player;
  Enemy _enemy;
  FireEffect(this._player, this._enemy) : super(EffectType.Gold, 'fire.png') {
    _timer = 0;
    _totalDuration = 4;
  }

  void update(t, x, y) {
    if (_timer > _totalDuration) {
      if (_player != null) {
        _player.health -= 3;
      } else if (_enemy != null) {
        _enemy.health -= 3;
      }
      type = EffectType.None;
    }
    super.update(t, x, y);
  }
}
