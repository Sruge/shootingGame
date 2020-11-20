import 'package:flutter/widgets.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class EnemyhealthBar {
  double _health;
  double _maxHealth;
  Rect _healthbarGreen;
  Rect _healthbarRed;
  Rect _healthbarBorder;
  double _barHeight;
  Paint paintGreen;
  Paint paintRed;
  Paint paintBlack;

  EnemyhealthBar(this._health, this._maxHealth) {
    _barHeight = screenSize.height * 0.015;
    paintGreen = Paint();
    paintRed = Paint();
    paintBlack = Paint();
    paintGreen.color = Color(0xff00ff00);
    paintRed.color = Color(0xffff0000);
    paintBlack.color = Color(0xff000000);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(_healthbarBorder, paintBlack);
    canvas.drawRect(_healthbarGreen, paintGreen);
    canvas.drawRect(_healthbarRed, paintRed);
  }

  void resize(double x, double y) {
    double greenSize = (_health / _maxHealth) * screenSize.width * 0.06;
    double redSize =
        ((_maxHealth - _health) / _maxHealth) * screenSize.width * 0.06;
    _healthbarGreen = Rect.fromLTWH(x, y - _barHeight, greenSize, _barHeight);
    _healthbarRed =
        Rect.fromLTWH(x + greenSize, y - _barHeight, redSize, _barHeight);
    _healthbarBorder = Rect.fromLTWH(
        x - 1, y - _barHeight - 1, greenSize + redSize + 2, _barHeight + 2);
  }

  void updateRect(double maxH, double h, double x, double y) {
    _maxHealth = maxH;
    _health = h;
    double greenSize = (_health / _maxHealth) * screenSize.width * 0.06;
    double redSize =
        ((_maxHealth - _health) / _maxHealth) * screenSize.width * 0.06;
    _healthbarGreen = Rect.fromLTWH(x, y - _barHeight, greenSize, _barHeight);
    _healthbarRed =
        Rect.fromLTWH(x + greenSize, y - _barHeight, redSize, _barHeight);
    _healthbarBorder = Rect.fromLTWH(
        x - 1, y - _barHeight - 1, greenSize + redSize + 2, _barHeight + 2);
  }
}
