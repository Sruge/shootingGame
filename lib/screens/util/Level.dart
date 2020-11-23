import 'package:shootinggame/enemies/Boss.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/PresentType.dart';

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
  Level(double score) {
    spawnInterval = 10 - score * 0.1;
    friendSpawnInterval = 20;
    bossSpawnInterval = 20;
    dmgMultiplier = 1;
    bulletLifetimeMultiplier = 1 + score / 100;
    attackRangeMultiplier = 1;
    attackIntervalMultiplier = 1;
    maxEnemies = 6;
    presentSpawnInterval = 5;
    enemyTypes = [EnemyType.One];
    presentTypes = [PresentType.Bullets, PresentType.Health, PresentType.Coin];
    if (score > 10) {
      enemyTypes.add(EnemyType.Two);
    }
    if (score > 20) {
      enemyTypes.add(EnemyType.Three);
    }
    if (score > 30) {
      enemyTypes.add(EnemyType.Four);
      presentTypes.add(PresentType.Freeze);
    }
    if (score > 40) {
      enemyTypes.add(EnemyType.Five);
    }
    Boss boss = Boss();
    boss.resize();
    bosses = [boss];
  }
}
