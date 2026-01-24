class CategoryModel {
  final int? id;
  final String? userId;

  final String name;
  final String? icon;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    this.id,
    this.userId,
    required this.name,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) return DateTime.tryParse(v)?.toLocal();
    if (v is DateTime) return v.toLocal();
    return null;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num?)?.toInt(),
      userId: json['user_id']?.toString(),
      name: (json['name'] ?? '').toString(),
      icon: json['icon']?.toString(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  /// INSERT
  Map<String, dynamic> toCreateMap({required String userId}) => {
        'user_id': userId,
        'name': name,
        'icon': icon,
      };

  /// UPDATE
  Map<String, dynamic> toUpdateMap() => {
        'name': name,
        'icon': icon,
      };
}
