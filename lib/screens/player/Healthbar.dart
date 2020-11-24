import 'dart:ui';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import '../BaseWidget.dart';
import 'Player.dart';

class Healthbar {
  Rect _healthbarGreen;
  Rect _healthbarRed;
  Rect _healthbarBorder;
  Rect _bulletCountRect;
  SpriteComponent _coinsRect;
  Rect _scoreRect;
  int _bulletCount;
  double maxHealth;
  double health;
  TextPainter tpBullets;
  TextPainter tpCoins;
  TextPainter tpScore;
  Offset bulletsTextOffset;
  Offset coinsTextOffset;
  Offset scoreTextOffset;
  int _coins;
  int _score;

  Healthbar(this.maxHealth, this.health, this._bulletCount, this._coins,
      this._score) {
    double greenSize = (health / maxHealth) * 100;
    double redSize = ((maxHealth - health) / maxHealth) * 100;
    _healthbarGreen =
        Rect.fromLTWH(screenSize.width / 3, 20, greenSize * 2, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize * 2, 30);
    _healthbarBorder = Rect.fromLTWH(
        screenSize.width / 3 - 2, 18, greenSize + redSize + 4, 34);
    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 40, 18, 34, 34);

    tpBullets = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 40, 18, 34, 34);

    tpCoins = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 40, 18, 34, 34);

    tpScore = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  void render(Canvas canvas) {
    Paint paintGreen = Paint();
    paintGreen.color = Color(0xff00ff00);
    Paint paintRed = Paint();
    paintRed.color = Color(0xffff0000);
    Paint paintBlack = Paint();
    paintBlack.color = Color(0xff000000);
    Paint paintBullet = Paint();
    paintBullet.color = Color(0xffdcb430);
    Paint paintCoins = Paint();
    paintCoins.color = Color(0xfff8f004);
    Paint paintScore = Paint();
    paintScore.color = Color(0xff50006c);
    canvas.save();
    canvas.drawRect(_healthbarBorder, paintBlack);
    canvas.drawRect(_healthbarGreen, paintGreen);
    canvas.drawRect(_healthbarRed, paintRed);
    canvas.drawRect(_bulletCountRect, paintBullet);
    canvas.drawRect(_scoreRect, paintScore);
    _coinsRect.render(canvas);
    tpBullets.paint(canvas, bulletsTextOffset);
    tpScore.paint(canvas, scoreTextOffset);
    tpCoins.paint(canvas, coinsTextOffset);
    canvas.restore();
  }

  void resize() {
    double greenSize = (health / maxHealth) * 100;
    double redSize = ((maxHealth - health) / maxHealth) * 100;
    _healthbarGreen =
        Rect.fromLTWH(screenSize.width / 3, 20, greenSize * 2, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize * 2, 30);
    _healthbarBorder = Rect.fromLTWH(
        screenSize.width / 3 - 2, 18, greenSize + redSize + 4, 34);
    _bulletCountRect = Rect.fromLTWH(screenSize.width / 1.5 + 20, 18, 34, 34);
    _scoreRect = Rect.fromLTWH(screenSize.width / 1.5 + 60, 18, 34, 34);
    _coinsRect = SpriteComponent.fromSprite(34, 34, Sprite('coinsCount.png'));
    _coinsRect.x = screenSize.width / 1.5 + 100;
    _coinsRect.y = 18;
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

  void updateCounts(int bulletCount, int score, int coins) {
    _bulletCount = bulletCount;
    _coins = coins;
    _score = score;
    tpBullets.text = TextSpan(
      text: (_bulletCount).toString(),
      style: TextStyle(color: Color(0xffffffff), fontSize: 25),
    );
    tpBullets.layout();
    bulletsTextOffset = Offset(
      _bulletCountRect.center.dx - (tpBullets.width / 2),
      _bulletCountRect.top +
          (_bulletCountRect.height * .5) -
          (tpBullets.height / 2),
    );

    tpScore.text = TextSpan(
      text: (_score).toString(),
      style: TextStyle(color: Color(0xffffffff), fontSize: 25),
    );
    tpScore.layout();
    scoreTextOffset = Offset(
      _scoreRect.center.dx - (tpScore.width / 2),
      _scoreRect.top + (_scoreRect.height * .5) - (tpScore.height / 2),
    );

    tpCoins.text = TextSpan(
      text: (_coins).toString(),
      style: TextStyle(color: Color(0xffffffff), fontSize: 25),
    );
    tpCoins.layout();
    coinsTextOffset = Offset(
      (_coinsRect.x - _coinsRect.width) / 2 - (tpCoins.width / 2),
      _coinsRect.y + (_coinsRect.height * .5) - (tpCoins.height / 2),
    );
  }

  void update(double maxH, double h, int bullets, int score, int coins) {
    updateRect(maxH, h);
    updateCounts(bullets, score, coins);
  }

  void onTapDown(TapDownDetails detail, Function fn, Player player) {
    if (_healthbarBorder.contains(detail.globalPosition)) {
      player.move = false;
      fn();
    }
  }

  void setSpeed(List<double> speed) {}
}
