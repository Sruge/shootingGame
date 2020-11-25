import 'dart:ui';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'Player.dart';

class Healthbar {
  Rect _healthbarGreen;
  Rect _healthbarRed;
  Rect _healthbarBorder;
  SpriteComponent _coinsRect;
  SpriteComponent _bulletsRect;
  Rect _scoreRect;
  int _bulletCount;
  double maxHealth;
  double health;
  TextPainter tpBullets;
  TextPainter tpCoins;
  TextPainter tpScore;
  TextPainter tpHealth;
  Offset bulletsTextOffset;
  Offset coinsTextOffset;
  Offset scoreTextOffset;
  Offset healthTextOffset;

  int _coins;
  int _score;
  Paint paintGreen;
  Paint paintRed;
  Paint paintBlack;
  Paint paintBullet;
  Paint paintScore;

  Healthbar(this.maxHealth, this.health, this._bulletCount, this._coins,
      this._score) {
    paintGreen = Paint();
    paintGreen.color = Color(0xff00ff00);
    paintRed = Paint();
    paintRed.color = Color(0xffff0000);
    paintBlack = Paint();
    paintBlack.color = Color(0xff000000);
    paintBullet = Paint();
    paintBullet.color = Color(0xffdcb430);
    paintScore = Paint();
    paintScore.color = Color(0xff50006c);

    double greenSize = (health / maxHealth) * 100;
    double redSize = ((maxHealth - health) / maxHealth) * 100;
    _healthbarGreen =
        Rect.fromLTWH(screenSize.width / 3, 20, greenSize * 2, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize * 2, 30);
    _healthbarBorder = Rect.fromLTWH(
        screenSize.width / 3 - 2, 18, greenSize + redSize + 4, 34);

    tpBullets = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tpCoins = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tpScore = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tpHealth = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  void render(Canvas canvas) {
    canvas.save();
    canvas.drawRect(_healthbarBorder, paintBlack);
    canvas.drawRect(_healthbarGreen, paintGreen);
    canvas.drawRect(_healthbarRed, paintRed);
    canvas.drawRect(_scoreRect, paintScore);
    canvas.save();
    _coinsRect.render(canvas);
    canvas.restore();
    canvas.save();
    _bulletsRect.render(canvas);
    canvas.restore();
    tpBullets.paint(canvas, bulletsTextOffset);
    tpScore.paint(canvas, scoreTextOffset);
    tpCoins.paint(canvas, coinsTextOffset);
    tpHealth.paint(canvas, healthTextOffset);
  }

  void resize() {
    double greenSize = (health / maxHealth) * 100;
    double redSize = ((maxHealth - health) / maxHealth) * 100;
    _healthbarGreen =
        Rect.fromLTWH(screenSize.width / 3, 20, greenSize * 2, 30);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize * 2, 30);
    _healthbarBorder = Rect.fromLTWH(
        (screenSize.width - 100) / 2, 18, greenSize + redSize + 4, 32);
    _scoreRect = Rect.fromLTWH(screenSize.width / 3 - 10 - 48, 18, 48, 32);
    _bulletsRect =
        SpriteComponent.fromSprite(48, 32, Sprite('bulletcount.png'));
    _bulletsRect.x = screenSize.width / 1.5 + 10;
    _bulletsRect.y = 18;
    _coinsRect = SpriteComponent.fromSprite(34, 34, Sprite('coinsCount.png'));
    _coinsRect.x = screenSize.width / 1.5 + 20 + _bulletsRect.width;
    _coinsRect.y = 18;
  }

  void updateRect(double maxH, double h) {
    maxHealth = maxH;
    health = h;
    double greenSize = (health / maxHealth) * screenSize.width / 3;
    double redSize = ((maxHealth - health) / maxHealth) * screenSize.width / 3;
    _healthbarGreen = Rect.fromLTWH(screenSize.width / 3, 20, greenSize, 28);
    _healthbarRed =
        Rect.fromLTWH(screenSize.width / 3 + greenSize, 20, redSize, 28);
    _healthbarBorder = Rect.fromLTWH(
        (screenSize.width - screenSize.width / 3) / 2 - 2,
        18,
        greenSize + redSize + 4,
        32);
    tpHealth.text = TextSpan(
      text: '${h.toInt()}/${maxH.toInt()}',
      style: TextStyle(color: Color(0xffffffff), fontSize: 16),
    );
    tpHealth.layout();
    healthTextOffset = Offset((screenSize.width - tpHealth.width) / 2,
        _healthbarBorder.top + (_healthbarBorder.height - tpHealth.height) / 2);
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
      _bulletsRect.x + ((_bulletsRect.width - tpBullets.width) / 2),
      _bulletsRect.y + ((_bulletsRect.height - tpBullets.height) / 2),
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
      _coinsRect.x + ((_coinsRect.width - tpCoins.width) / 2),
      _coinsRect.y + ((_coinsRect.height - tpCoins.height) / 2),
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
