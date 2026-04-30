import 'package:dio/dio.dart';
import '../core/api_client.dart';

class CareerQuestion {
  final int id;
  final String text;
  final String category;

  CareerQuestion({required this.id, required this.text, required this.category});

  factory CareerQuestion.fromJson(Map<String, dynamic> json) {
    return CareerQuestion(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String? ?? '',
    );
  }
}

class CareerTestRepository {
  static final _dio = ApiClient.instance;

  static Future<List<CareerQuestion>> loadQuestions({String lang = 'ru'}) async {
    final response = await _dio.get('/career-test/questions', queryParameters: {'lang': lang});
    final list = response.data as List;
    return list.map((e) => CareerQuestion.fromJson(e as Map<String, dynamic>)).toList();
  }

  // answers: { questionId → rating (1–5) }
  static Future<String> submitAnswers(Map<int, int> answers) async {
    final response = await _dio.post('/career-test/submit', data: {
      'answers': answers.entries
          .map((e) => {'questionId': e.key, 'rating': e.value})
          .toList(),
    });
    return response.data['dominantCode'] as String;
  }

  static String friendlyError(Object e) {
    if (e is DioException) {
      if (e.response == null) return 'Нет соединения с сервером';
      return 'Ошибка сервера (${e.response?.statusCode})';
    }
    return e.toString();
  }
}
