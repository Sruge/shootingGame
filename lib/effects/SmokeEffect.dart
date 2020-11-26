import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

class SmokeEffect extends Effect {
  Player _player;
  Enemy _enemy;
  SmokeEffect(this._player, this._enemy)
      : super(EffectType.Gold, 'smoke.png', _player, _enemy) {}

  void update(t, x, y) {
    if (_player != null) {
      _player.health -= t * 10;
    } else if (_enemy != null) {
      _enemy.health -= t;
    }
    super.update(t, x, y);
  }
}
