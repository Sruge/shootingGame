import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

class SmokeEffect extends Effect {
  Player _player;
  Enemy _enemy;
  double _power;
  SmokeEffect(this._player, this._enemy, this._power)
      : super(EffectType.Gold, 'smoke.png', _player, _enemy) {}

  void update(t, x, y) {
    if (_player != null) {
      _player.health -= t * _power * 3;
    } else if (_enemy != null) {
      _enemy.health -= t * 3 * _power;
    }
    super.update(t, x, y);
  }
}
