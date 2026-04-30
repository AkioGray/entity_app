class University {
  final int id;
  final String name;
  final String city;
  final double? rating;
  final double? tuitionFeeMin;
  final double? tuitionFeeMax;
  final String? logoUrl;
  final String? studyForm;
  final bool? accredited;
  final String? website;

  University({
    required this.id,
    required this.name,
    required this.city,
    this.rating,
    this.tuitionFeeMin,
    this.tuitionFeeMax,
    this.logoUrl,
    this.studyForm,
    this.accredited,
    this.website,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      tuitionFeeMin: (json['tuitionFeeMin'] as num?)?.toDouble(),
      tuitionFeeMax: (json['tuitionFeeMax'] as num?)?.toDouble(),
      logoUrl: json['logoUrl'] as String?,
      studyForm: json['studyForm'] as String?,
      accredited: json['accredited'] as bool?,
      website: json['website'] as String?,
    );
  }
}
