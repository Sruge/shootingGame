import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

class GoldenEffect extends Effect {
  GoldenEffect(Player player, Enemy enemy)
      : super(EffectType.Gold, 'goldenBullet.png', player, enemy) {}
}
