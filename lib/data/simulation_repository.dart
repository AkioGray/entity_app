import '../globals.dart';

class SimulationRepository {
  static Future<double> calculateChance({
    required int prof1,
    required int prof2,
    required int history,
    required int reading,
    required int math,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (prof1 < 5 || prof2 < 5 || history < 5 || reading < 3 || math < 3) {
      return 0.0;
    }

    int total = prof1 + prof2 + history + reading + math;
    double chance = total / 140.0;

    if (globalHasQuota.value) chance += 0.08;
    if (globalSchoolType.value == 'rural') chance += 0.05;
    if (globalRegion.value == 'Алматы' || globalRegion.value == 'Астана') {
      chance -= 0.04;
    }

    if (chance > 0.99) chance = 0.99;
    if (chance < 0.02) chance = 0.02;

    return chance;
  }
}