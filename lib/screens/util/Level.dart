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

class Level {
  double spawnInterval;
  double friendSpawnInterval;
  double bossSpawnInterval;
  double presentSpawnInterval;
  double maxEnemies;

  double dmgMultiplier;
  double bulletLifetimeMultiplier;
  double attackRangeMultiplier;
  double attackIntervalMultiplier;
  double enemySpeedMultiplier;
  List<EnemyType> enemyTypes;
  List<PresentType> presentTypes;
  List<Enemy> bosses;
  Level(int level) {
    spawnInterval = 20;
    friendSpawnInterval = 20;
    bossSpawnInterval = 70;
    dmgMultiplier = 1;
    bulletLifetimeMultiplier = 1 + level * 0.1;
    attackRangeMultiplier = 1;
    attackIntervalMultiplier = 1 - level * 0.02;
    maxEnemies = 6;
    presentSpawnInterval = 15;
    enemyTypes = [EnemyType.One];
    bosses = List.empty(growable: true);
    presentTypes = [PresentType.Bullets, PresentType.Health, PresentType.Coin];
    if (level > 3) {
      enemyTypes.add(EnemyType.Two);
      Boss boss = Boss();
      boss.resize();
      bosses.add(boss);
    }
    if (level > 6) {
      enemyTypes.add(EnemyType.Three);
      Killer killer = Killer();
      killer.resize();
      bosses.add(killer);
      attackRangeMultiplier = 2;
    }
    if (level > 9) {
      Phoenix phoenix = Phoenix();
      phoenix.resize();
      bosses.add(phoenix);
      presentTypes.add(PresentType.Freeze);
      dmgMultiplier = 2;
      spawnInterval = 7;
    }
    if (level > 12) {
      enemyTypes.add(EnemyType.Four);

      Russia russia = Russia();
      russia.resize();
      bosses.add(russia);
    }
    if (level > 15) {
      Princessserenity princessserenity = Princessserenity();
      princessserenity.resize();
      bosses.add(princessserenity);
      //spawnInterval = 2;
    }
    if (level > 18) {
      enemyTypes.add(EnemyType.Five);
      Leviathan leviathan = Leviathan();
      leviathan.resize();
      bosses.add(leviathan);
    }
    if (level > 21) {
      Altima altima = Altima();
      altima.resize();
      bosses.add(altima);
    }
    if (level > 24) {
      Kainhighwind kainhighwind = Kainhighwind();
      kainhighwind.resize();
      bosses.add(kainhighwind);
    }
    if (level > 27) {
      Bahamut bahamut = Bahamut();
      bahamut.resize();
      bosses.add(bahamut);
    }
  }
}
