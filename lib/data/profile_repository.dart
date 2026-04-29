import '../globals.dart';

class ProfileRepository {
  static Future<void> fetchUserData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    globalRegion.value = 'Алматы';
    globalSchoolType.value = 'city';
    globalHasQuota.value = false;
    
    // ИСПРАВЛЕНИЕ: Используем новые переменные вместо globalComboIndex
    globalProf1.value = 'Математика';
    globalProf2.value = 'Физика';
  }

  static Future<bool> saveUserData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}