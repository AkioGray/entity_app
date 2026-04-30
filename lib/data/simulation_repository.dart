import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../globals.dart';
import '../models/profession.dart';
import '../models/grant_result.dart';

class SimulationRepository {
  static final _dio = ApiClient.instance;

  // Локальный расчёт — мгновенный отклик для слайдеров
  static double calculateChance({
    required int prof1,
    required int prof2,
    required int history,
    required int reading,
    required int math,
  }) {
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

    return chance.clamp(0.02, 0.99);
  }

  static Future<List<Profession>> loadProfessions({String lang = 'ru'}) async {
    final response = await _dio.get('/professions', queryParameters: {'lang': lang});
    final list = response.data as List;
    return list.map((e) => Profession.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<({String professionName, List<GrantResult> results})> checkGrants({
    required int entScore,
    required int professionId,
    String lang = 'ru',
  }) async {
    final response = await _dio.post('/grants/check', data: {
      'entScore': entScore,
      'professionId': professionId,
      'lang': lang,
    });

    final data = response.data as Map<String, dynamic>;
    final results = (data['results'] as List)
        .map((e) => GrantResult.fromJson(e as Map<String, dynamic>))
        .toList();

    return (professionName: data['professionName'] as String, results: results);
  }

  static String friendlyError(Object e) {
    if (e is DioException) {
      if (e.response == null) return 'Нет соединения с сервером';
      return 'Ошибка сервера (${e.response?.statusCode})';
    }
    return e.toString();
  }
}
