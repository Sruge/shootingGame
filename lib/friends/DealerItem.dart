import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/bullets/BulletType.dart';
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
  int price;
  DealerItem(this._type, this.price) {
    x = y = 0;
    width = height = 0;
    clicked = false;
    switch (_type) {
      case DealerItemType.Bullets:
        button = SpriteComponent.fromSprite(0, 0, Sprite('bullets.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('bulletsout.png'));
        break;
      case DealerItemType.SpecialPower:
        button = SpriteComponent.fromSprite(0, 0, Sprite('rainbow.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('rainbowout.png'));
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
        button = SpriteComponent.fromSprite(0, 0, Sprite('range.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('rangeout.png'));
        break;
      case DealerItemType.MaxHealth:
        button = SpriteComponent.fromSprite(0, 0, Sprite('maxHealth.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('maxHealthout.png'));
        break;
      case DealerItemType.MaxBullets:
        button = SpriteComponent.fromSprite(0, 0, Sprite('maxBullets.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('maxBulletsout.png'));
        break;
      case DealerItemType.Damage:
        button = SpriteComponent.fromSprite(0, 0, Sprite('damage.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('damageout.png'));
        break;
      case DealerItemType.BulletType2:
        button = SpriteComponent.fromSprite(0, 0, Sprite('bulletType2.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('bulletType2out.png'));
        break;
      case DealerItemType.BulletType3:
        button = SpriteComponent.fromSprite(0, 0, Sprite('bulletType3.png'));
        buttonClicked =
            SpriteComponent.fromSprite(0, 0, Sprite('bulletType3out.png'));
        break;
      default:
    }
  }
  void onTapDown(TapDownDetails detail, Player player) {
    if (!clicked && player.coins >= price) {
      if (button.toRect().contains(detail.globalPosition)) {
        clicked = true;
        player.coins -= price;
        switch (_type) {
          case DealerItemType.Bullets:
            player.bulletCount = player.maxBulletCount;
            print('Refilled the players bullets');
            break;
          case DealerItemType.SpecialPower:
            player.specialPower += 1;
            print('Special Bullets: Nothing happening at the moment');
            break;
          case DealerItemType.Health:
            player.effects.add(HealEffect(player, null));
            print('Added Heal Effect to the player');
            break;
          case DealerItemType.Slot:
            player.addSlot();
            print('Added a slot if not already three');
            break;
          case DealerItemType.Speed:
            player.speedfactor = player.speedfactor * 1.2;
            print('New Speedfactor: ${player.speedfactor}');
            break;
          case DealerItemType.Range:
            player.bulletLifetimeFctr += 0.2;
            print('New Range: ${player.bulletLifetimeFctr}');
            break;
          case DealerItemType.BulletType2:
            player.bulletType = BulletType.Two;
            print('Now using BulletType Two');
            break;
          case DealerItemType.BulletType3:
            player.bulletType = BulletType.Three;
            print('Now using BulletType Three');
            break;
          case DealerItemType.MaxHealth:
            player.maxHealth += 50;
            print('Increasing maxHealth by 50');
            break;
          case DealerItemType.MaxBullets:
            player.maxBulletCount += 25;
            print('Increasing maxBullets by 25');
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
