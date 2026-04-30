class GrantResult {
  final String universityName;
  final String city;
  final String chance;
  final int? minEntScore;
  final int? totalGrants;
  final int? year;

  GrantResult({
    required this.universityName,
    required this.city,
    required this.chance,
    this.minEntScore,
    this.totalGrants,
    this.year,
  });

  factory GrantResult.fromJson(Map<String, dynamic> json) {
    return GrantResult(
      universityName: json['universityName'] as String,
      city: json['city'] as String,
      chance: json['chance'] as String,
      minEntScore: json['minEntScore'] as int?,
      totalGrants: json['totalGrants'] as int?,
      year: json['year'] as int?,
    );
  }
}
