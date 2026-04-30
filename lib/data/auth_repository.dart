import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/auth_storage.dart';
import '../globals.dart';

class AuthRepository {
  static final _dio = ApiClient.instance;

  static Future<void> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final token = response.data['token'] as String;
    await AuthStorage.saveToken(token);

    globalUserName.value = '${response.data['firstName']} ${response.data['lastName']}';
    globalUserEmail.value = response.data['email'] as String;
  }

  static Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String profileSubject1,
    required String profileSubject2,
  }) async {
    final response = await _dio.post('/auth/register', data: {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'profileSubject1': profileSubject1,
      'profileSubject2': profileSubject2,
    });

    final token = response.data['token'] as String;
    await AuthStorage.saveToken(token);

    globalUserName.value = '$firstName $lastName';
    globalUserEmail.value = email;
    globalProf1.value = profileSubject1;
    globalProf2.value = profileSubject2;
  }

  static String _parseError(DioException e) {
    if (e.response?.data is Map) {
      final msg = e.response?.data['message'] ?? e.response?.data['error'];
      if (msg != null) return msg.toString();
    }
    return switch (e.response?.statusCode) {
      401 => 'Неверный email или пароль',
      409 => 'Пользователь с таким email уже существует',
      400 => 'Проверьте введённые данные',
      null => 'Нет соединения с сервером',
      _ => 'Ошибка сервера (${e.response?.statusCode})',
    };
  }

  static String friendlyError(Object e) {
    if (e is DioException) return _parseError(e);
    return e.toString();
  }
}
