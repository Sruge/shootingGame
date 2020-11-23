import 'package:shootinggame/effects/Effect.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/player/Player.dart';

class PurpleEffect extends Effect {
  PurpleEffect(Player player, Enemy enemy)
      : super(EffectType.Gold, 'purpleBullets.png') {}
}
