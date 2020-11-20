import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class BaseWidget {
  double speedfactor;
  void resize();

  void render(Canvas canvas);

  void update(double t);

  void onTapDown(TapDownDetails detail, Function fn);
}
