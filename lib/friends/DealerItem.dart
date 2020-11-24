import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/HealEffect.dart';
import 'package:shootinggame/friends/DealerItemType.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';

class DealerItem {
  PositionComponent button;
  PositionComponent buttonClicked;
  double x, y;
  bool clicked;
  double width, height;
  DealerItemType _type;
  int _price;
  DealerItem(this._type, this._price) {
    x = y = 0;
    width = height = 0;
    clicked = false;
    switch (_type) {
      case DealerItemType.Bullets:
        button = SpriteComponent.fromSprite(0, 0, Sprite('speed.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('speedout.png'));

        break;
      case DealerItemType.SpecialBullets:
        button = SpriteComponent.fromSprite(0, 0, Sprite('speed.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('speedout.png'));

        break;
      case DealerItemType.Health:
        button = SpriteComponent.fromSprite(0, 0, Sprite('heal.png'));
        buttonClicked = SpriteComponent.fromSprite(0, 0, Sprite('healout.png'));

        break;
      case DealerItemType.Slot:
        button = SpriteComponent.fromSprite(0, 0, Sprite('slot.png'));
        buttonClicked = SpriteComponent.fromSprite(0, 0, Sprite('slotout.png'));

        break;
      case DealerItemType.Speed:
        button = SpriteComponent.fromSprite(0, 0, Sprite('speed.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('speedout.png'));

        break;
      case DealerItemType.Range:
        button = SpriteComponent.fromSprite(0, 0, Sprite('speed.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('speedout.png'));
        break;
      default:
    }
  }
  void onTapDown(TapDownDetails detail, Player player) {
    if (!clicked && player.coins >= _price) {
      if (button.toRect().contains(detail.globalPosition)) {
        clicked = true;
        player.coins -= _price;
        switch (_type) {
          case DealerItemType.Bullets:
            print(_type);
            player.bulletCount += 20;
            break;
          case DealerItemType.SpecialBullets:
            print(_type);
            break;
          case DealerItemType.Health:
            print(_type);
            player.effects.add(HealEffect(player, null));
            break;
          case DealerItemType.Slot:
            player.addSlot();
            print(_type);
            break;
          case DealerItemType.Speed:
            print(_type);
            screenManager.setSpeedfactor(1.2, false);
            break;
          case DealerItemType.Range:
            player.bulletLifetimeFctr += 1;
            print(_type);
            break;
          default:
            print('Default');
        }
      }
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    if (clicked) {
      buttonClicked.render(canvas);
    } else {
      button.render(canvas);
    }
    canvas.restore();
  }

  void resize(double x, double y, double width, double height) {
    button.x = buttonClicked.x = x;
    button.y = buttonClicked.y = y;
    button.width = buttonClicked.width = width;
    button.height = buttonClicked.height = height;
  }
}
