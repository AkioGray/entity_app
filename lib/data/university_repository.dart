import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/university.dart';

class UniversityRepository {
  static final _dio = ApiClient.instance;

  static Future<List<String>> getFilterCities() async {
    final response = await _dio.get('/universities/cities');
    return List<String>.from(response.data as List);
  }

  static Future<List<University>> getUniversities({
    required int page,
    String? cityFilter,
    String? searchQuery,
    String lang = 'ru',
  }) async {
    final response = await _dio.get('/universities/search', queryParameters: {
      if (cityFilter != null && cityFilter.isNotEmpty) 'city': cityFilter,
      if (searchQuery != null && searchQuery.isNotEmpty) 'query': searchQuery,
      'page': page,
      'size': 10,
      'lang': lang,
    });

    final content = response.data['content'] as List;
    return content.map((e) => University.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String friendlyError(Object e) {
    if (e is DioException) {
      if (e.response == null) return 'Нет соединения с сервером';
      return 'Ошибка сервера (${e.response?.statusCode})';
    }
    return e.toString();
  }
}
