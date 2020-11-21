import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/enemies/EffectType.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class Effect {
  EffectType _type;
  AnimationComponent _effect;
  double _totalDuration, _timer;
  Effect(this._type, this._totalDuration) {
    _timer = 0;
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
      case EffectType.Freeze:
        final sprShe = SpriteSheet(
            imageName: 'frozen.png',
            textureWidth: 32,
            textureHeight: 24,
            columns: 4,
            rows: 1);
        final ani = sprShe.createAnimation(0, stepTime: 0.1);
        _effect = AnimationComponent(100, 100, ani);
        break;
      default:
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    _effect.render(canvas);
    canvas.restore();
  }

  void update(double t, double x, double y) {
    _timer += t;
    _effect.update(t);
    if (_timer > _totalDuration) {
      _type = EffectType.None;
    }
    _effect.x = x;
    _effect.y = y;
  }

  void resize(double x, double y) {
    _effect.x = x;
    _effect.y = y;
    _effect.width = screenSize.width * 0.06;
    _effect.height = screenSize.height * 0.14;
  }

  EffectType getType() {
    return _type;
  }
}
