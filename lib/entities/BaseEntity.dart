import 'dart:ui';

import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/player/Player.dart';

abstract class BaseEntity extends BaseWidget {
  bool isDead();

  void hit(Player player);

  bool overlaps(Rect rect);
}
