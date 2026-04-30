import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../globals.dart';

class ProfileRepository {
  static final _dio = ApiClient.instance;

  static Future<void> fetchUserData() async {
    final response = await _dio.get('/users/me');
    final data = response.data as Map<String, dynamic>;

    globalUserName.value = '${data['firstName']} ${data['lastName']}';
    globalUserEmail.value = data['email'] as String;
    globalProf1.value = data['profileSubject1'] as String? ?? '';
    globalProf2.value = data['profileSubject2'] as String? ?? '';
    globalRegion.value = data['region'] as String?;
    globalSchoolType.value = data['schoolType'] as String? ?? 'urban';
    globalHasQuota.value = data['hasQuota'] as bool? ?? false;
  }

  static Future<void> saveUserData() async {
    await Future.wait([
      _dio.put('/users/me/profile-subjects', data: {
        'profileSubject1': globalProf1.value,
        'profileSubject2': globalProf2.value,
      }),
      _dio.put('/users/me/sim-params', data: {
        'region': globalRegion.value,
        'schoolType': globalSchoolType.value,
        'hasQuota': globalHasQuota.value,
      }),
    ]);
  }

  static String friendlyError(Object e) {
    if (e is DioException) {
      if (e.response?.data is Map) {
        final msg = e.response?.data['message'];
        if (msg != null) return msg.toString();
      }
      if (e.response == null) return 'Нет соединения с сервером';
      return 'Ошибка сервера (${e.response?.statusCode})';
    }
    return e.toString();
  }
}
