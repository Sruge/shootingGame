import 'dart:ui';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import '../BaseWidget.dart';

class Healthbar extends BaseWidget {
  Rect _healthbarGreen;
  Rect _healthbarRed;
  Rect _healthbarBorder;
  Rect _bulletCountRect;
  int _bulletCount;
  double maxHealth;
  double health;
  TextPainter tp;
  Offset textOffset;

  Healthbar(this.maxHealth, this.health, this._bulletCount) {
    double greenSize = (health / maxHealth) * 100;
    double redSize = ((maxHealth - health) / maxHealth) * 100;
    _healthbarGreen =
        Rect.fromLTWH(screenSize.width / 3, 20, greenSize * 2, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize * 2, 30);
    _healthbarBorder = Rect.fromLTWH(
        screenSize.width / 3 - 2, 18, greenSize + redSize + 4, 34);
    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 40, 18, 34, 34);

    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  @override
  void render(Canvas canvas) {
    Paint paintGreen = Paint();
    paintGreen.color = Color(0xff00ff00);
    Paint paintRed = Paint();
    paintRed.color = Color(0xffff0000);
    Paint paintBlack = Paint();
    paintBlack.color = Color(0xff000000);
    canvas.drawRect(_healthbarBorder, paintBlack);
    canvas.drawRect(_healthbarGreen, paintGreen);
    canvas.drawRect(_healthbarRed, paintRed);
    canvas.drawRect(_bulletCountRect, paintBlack);
    tp.paint(canvas, textOffset);
  }

  @override
  void resize() {
    double greenSize = (health / maxHealth) * 100;
    double redSize = ((maxHealth - health) / maxHealth) * 100;
    _healthbarGreen =
        Rect.fromLTWH(screenSize.width / 3, 20, greenSize * 2, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize * 2, 30);
    _healthbarBorder = Rect.fromLTWH(
        screenSize.width / 3 - 2, 18, greenSize + redSize + 4, 34);
    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 40, 18, 34, 34);
  }

  void updateRect(double maxH, double h) {
    maxHealth = maxH;
    health = h;
    double greenSize = (health / maxHealth) * 250;
    double redSize = ((maxHealth - health) / maxHealth) * 250;
    _healthbarGreen = Rect.fromLTWH(screenSize.width / 3, 20, greenSize, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize, 30);
    _healthbarBorder = Rect.fromLTWH(
        screenSize.width / 3 - 2, 18, greenSize + redSize + 4, 34);
  }

  void updateBulletCount(int bulletCount) {
    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 40, 18, 34, 34);
    _bulletCount = bulletCount;
    tp.text = TextSpan(
      text: (_bulletCount).toInt().toString(),
      style: TextStyle(color: Color(0xffffffff), fontSize: 25),
    );
    tp.layout();
    textOffset = Offset(
      _bulletCountRect.center.dx - (tp.width / 2),
      _bulletCountRect.top + (_bulletCountRect.height * .4) - (tp.height / 2),
    );
  }

  @override
  void update(double t) {}

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (_healthbarBorder.contains(detail.globalPosition)) fn();
  }

  void setSpeed(List<double> speed) {}
}
