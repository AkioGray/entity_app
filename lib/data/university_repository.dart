import '../models/university.dart';

class UniversityRepository {
  static final List<University> _mockDatabase = List.generate(40, (index) {
    final cities = ['Астана', 'Алматы', 'Шымкент', 'Караганда'];
    return University(
      id: index.toString(),
      name: 'Университет ${index + 1}',
      city: cities[index % cities.length],
      minScore: 75 + (index % 40),
      grantChance: 0.1 + ((index * 2) % 90) / 100,
      tuitionFee: 800000 + (index * 50000),
    );
  });

  static Future<List<String>> getFilterCities() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDatabase.map((e) => e.city).toSet().toList();
  }

  static Future<List<University>> getUniversities({required int page, String? cityFilter, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    List<University> filtered = _mockDatabase;
    
    if (cityFilter != null && cityFilter.isNotEmpty) {
      filtered = filtered.where((u) => u.city == cityFilter).toList();
    }
    
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      filtered = filtered.where((u) => u.name.toLowerCase().contains(searchQuery.toLowerCase().trim())).toList();
    }

    final int pageSize = 10;
    final int startIndex = page * pageSize;
    
    if (startIndex >= filtered.length) {
      return [];
    }

    final int endIndex = (startIndex + pageSize > filtered.length) ? filtered.length : startIndex + pageSize;
    return filtered.sublist(startIndex, endIndex);
  }
}