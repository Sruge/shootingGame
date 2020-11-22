import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'Enemy.dart';

class Effect {
  EffectType _type;
  AnimationComponent _effect;
  double _totalDuration, _timer;
  Player _player;
  double _initialSpeed;
  Enemy _enemy;
  bool _renderSomething;
  Effect(this._type, this._totalDuration, this._player, this._enemy) {
    _timer = 0;
    _renderSomething = true;
    switch (_type) {
      case EffectType.Fire:
        final sprShe = SpriteSheet(
            imageName: 'fire.png',
            textureWidth: 32,
            textureHeight: 24,
            columns: 4,
            rows: 1);
        final ani = sprShe.createAnimation(0, stepTime: 0.1);
        _effect = AnimationComponent(100, 100, ani);
        break;
      case EffectType.Purple:
        final sprShe = SpriteSheet(
            imageName: 'purpleBullets.png',
            textureWidth: 32,
            textureHeight: 24,
            columns: 4,
            rows: 1);
        final ani = sprShe.createAnimation(0, stepTime: 0.1);
        _effect = AnimationComponent(100, 100, ani);
        break;
      case EffectType.Freeze:
        final sprShe = SpriteSheet(
            imageName: 'frozen.png',
            textureWidth: 32,
            textureHeight: 24,
            columns: 4,
            rows: 1);
        final ani = sprShe.createAnimation(0, stepTime: 0.1);
        _effect = AnimationComponent(100, 100, ani);
        if (_player != null) {
          _initialSpeed = _player.speedfactor;
          screenManager.setSpeedfactor(0, true);
        } else if (_enemy != null) {
          _initialSpeed = _enemy.enemySpeedFactor;
          _enemy.enemySpeedFactor = 0;
        }
        break;
      case EffectType.Smoke:
        _renderSomething = false;
        // if (_player != null) {
        //   _initialSpeed = _player.speedfactor;
        //   screenManager.setSpeedfactor(0.5, false);
        // } else if (_enemy != null) {
        //   _initialSpeed = _enemy.enemySpeedFactor;
        //   _enemy.enemySpeedFactor = _enemy.enemySpeedFactor * 0.5;
        // }
        break;
      default:
        _renderSomething = false;
        break;
    }
  }

  void render(Canvas canvas) {
    if (_renderSomething) {
      canvas.save();
      _effect.render(canvas);
      canvas.restore();
    }
  }

  void update(double t, double x, double y) {
    _timer += t;
    if (_type == EffectType.Smoke) {
      _player.health -= t;
    }

    if (_timer > _totalDuration) {
      switch (_type) {
        case EffectType.Fire:
          if (_player != null) {
            _player.health -= _totalDuration;
          } else if (_enemy != null) {
            _enemy.health -= _totalDuration;
          }
          break;
        case EffectType.Freeze:
          if (_player != null) {
            screenManager.setSpeedfactor(_initialSpeed, true);
          } else if (_enemy != null) {
            _enemy.enemySpeedFactor = _initialSpeed;
          }
          break;
        case EffectType.Smoke:
          // if (_player != null) {
          //   screenManager.setSpeedfactor(_initialSpeed, true);
          // } else if (_enemy != null) {
          //   _enemy.enemySpeedFactor = _initialSpeed;
          // }
          break;
        default:
      }
      _type = EffectType.None;
    }
    if (_renderSomething) {
      _effect.x = x;
      _effect.y = y;
      _effect.update(t);
    }
  }

  void resize(double x, double y) {
    if (_renderSomething) {
      _effect.x = x;
      _effect.y = y;
      _effect.width = screenSize.width * 0.06;
      _effect.height = screenSize.height * 0.14;
    }
  }

  EffectType getType() {
    return _type;
  }
}
