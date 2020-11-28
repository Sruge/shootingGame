import 'dart:math';

import 'package:shootinggame/enemies/bosses/Altima.dart';
import 'package:shootinggame/enemies/bosses/Bahamut.dart';
import 'package:shootinggame/enemies/bosses/Boss.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/enemies/bosses/Kainhighwind.dart';
import 'package:shootinggame/enemies/bosses/Killer.dart';
import 'package:shootinggame/enemies/bosses/Leviathan.dart';
import 'package:shootinggame/enemies/bosses/Phoenix.dart';
import 'package:shootinggame/enemies/bosses/Princessserenity.dart';
import 'package:shootinggame/enemies/bosses/Russia.dart';
import 'package:shootinggame/screens/util/Spawner.dart';

import 'StoryHandler.dart';

class Level {
  double spawnInterval;
  double friendSpawnInterval;
  double bossSpawnInterval;
  double presentSpawnInterval;
  double treeSpawnInterval;
  double maxEnemies;

  double dmgMultiplier;
  double bulletLifetimeMultiplier;
  double attackRangeMultiplier;
  double attackIntervalMultiplier;
  double enemySpeedMultiplier;
  double healthMulti;
  double timeToNextLevel;
  double enemyBulletSpeed;
  double _bossPower;
  double treePower;

  List<EnemyType> enemyTypes;
  List<PresentType> presentTypes;
  List<Enemy> bosses;
  StoryHandler _storyHandler;
  Random _random;
  Level(int level, this._storyHandler) {
    _random = Random();
    spawnInterval = 10;
    bossSpawnInterval = 60;
    friendSpawnInterval = 20;
    presentSpawnInterval = 18;
    treeSpawnInterval = 100;
    timeToNextLevel = 40;

    _bossPower = 1;
    treePower = 1;
    dmgMultiplier = 1;
    bulletLifetimeMultiplier = 0.7;
    attackRangeMultiplier = 1;
    attackIntervalMultiplier = 1;
    healthMulti = 1;
    enemySpeedMultiplier = 0.2;
    enemyBulletSpeed = 1;

    maxEnemies = 4;
    enemyTypes = [EnemyType.One];
    bosses = List.empty(growable: true);
    presentTypes = [
      PresentType.Bullets,
      PresentType.Health,
      PresentType.Coin,
      PresentType.Blue,
      // PresentType.Colored,
      // PresentType.Golden,
      // PresentType.Red
    ];
    if (level > 1) {
      // Kainhighwind boss = Kainhighwind(_bossPower, _storyHandler);
      // boss.resize();
      // bosses.add(boss);

      // Killer killer = Killer(_bossPower);
      // killer.resize();
      // bosses.add(killer);

      // Phoenix phoenix = Phoenix(2);
      // phoenix.resize();
      // bosses.add(phoenix);

      // Russia russia = Russia();
      // russia.resize();
      // bosses.add(russia);

      // Leviathan leviathan = Leviathan();
      // leviathan.resize();
      // bosses.add(leviathan);

      // Boss boss = Boss(_bossPower);
      // boss.resize();
      // bosses.add(boss);

      spawnInterval = 7;
    }
    if (level > 2) {
      timeToNextLevel = 150;

      enemyTypes.add(EnemyType.Two);

      Russia russia = Russia(_bossPower);
      russia.resize();
      bosses.add(russia);

      enemyBulletSpeed = 1.1;
      enemySpeedMultiplier = 0.2;

      bulletLifetimeMultiplier = 1;
      dmgMultiplier = 1.2;
      attackIntervalMultiplier = 0.9;
      healthMulti = 1.5;
      spawnInterval = 10;
    }
    if (level > 3) {
      Phoenix phoenix = Phoenix(_bossPower);
      phoenix.resize();
      bosses.add(phoenix);
      enemyBulletSpeed = 1.2;
      enemySpeedMultiplier = 0.3;
      attackIntervalMultiplier = 0.5;
      dmgMultiplier = 2;
      healthMulti = 1.7;
      bulletLifetimeMultiplier = 2;
      spawnInterval = 10;
    }
    if (level > 4) {
      enemyTypes.add(EnemyType.Three);
      Boss boss = Boss(_bossPower);
      boss.resize();
      bosses.add(boss);

      Killer killer = Killer(_bossPower);
      killer.resize();
      bosses.add(killer);
      attackIntervalMultiplier = 1.2;
      dmgMultiplier = 2.5;
      healthMulti = 2;
      spawnInterval = 10;
    }
    if (level > 5) {
      enemyTypes.add(EnemyType.Four);

      Princessserenity princessserenity = Princessserenity(_bossPower);
      princessserenity.resize();
      bosses.add(princessserenity);
      spawnInterval = 6;
      enemySpeedMultiplier = 0.35;
      attackIntervalMultiplier = 0.8;
      spawnInterval = 26;
    }
    if (level > 6) {
      enemyTypes.add(EnemyType.Five);

      Leviathan leviathan = Leviathan(_bossPower);
      leviathan.resize();
      bosses.add(leviathan);

      enemyBulletSpeed = 1.4;
      dmgMultiplier = 4;
      healthMulti = 3;

      spawnInterval = 6;
    }
    if (level > 7) {
      enemyTypes.add(EnemyType.Six);

      Altima altima = Altima(_bossPower);
      altima.resize();
      bosses.add(altima);
      healthMulti = 8;
    }
    if (level > 8) {
      Kainhighwind kainhighwind = Kainhighwind(_bossPower, _storyHandler);
      kainhighwind.resize();
      bosses.add(kainhighwind);
      enemyBulletSpeed = 1.6;
      dmgMultiplier = 6;
      healthMulti = 5;
      spawnInterval = 4;
    }
    if (level > 9) {
      enemyTypes.add(EnemyType.PirateOne);
      enemyTypes.add(EnemyType.PirateTwo);
      enemyTypes.add(EnemyType.PirateThree);

      Bahamut bahamut = Bahamut(_bossPower);
      bahamut.resize();
      bosses.add(bahamut);

      enemySpeedMultiplier = 2;
      spawnInterval = 1;
    }
    print('Creating Level: $level: ${this.toString()}');
  }

  String toString() {
    String level = 'EnemyTypes: $enemyTypes, Bosses: $bosses, PresentTypes: $presentTypes, ' +
        'SpawnInterval: $spawnInterval BossSpawnInterval: $bossSpawnInterval, FriendSpawninterval: $friendSpawnInterval, PresentSpawnInterval: $presentSpawnInterval, TreeSpawnInterval: $treeSpawnInterval ' +
        'Damage: $dmgMultiplier, BulletLifeTime: $bulletLifetimeMultiplier, AttackRange: $attackRangeMultiplier, AttackInterval: $attackIntervalMultiplier, ' +
        'SpeedMultiplier: $enemySpeedMultiplier, BulletSpeedMultiplier: $enemyBulletSpeed HealthMulti: $healthMulti, Duration: $timeToNextLevel';
    return level;
  }
}
