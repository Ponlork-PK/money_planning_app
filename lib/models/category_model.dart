class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String type; // income, expense
  final String? color;
  final String? iconName;
  final bool? isDefault;
  final DateTime? createdAt;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.color,
    this.iconName,
    this.isDefault,
    this.createdAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'expense',
      color: map['color'],
      iconName: map['icon_name'],
      isDefault: map['is_default'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'type': type,
      'color': color,
      'icon_name': iconName,
    };
  }
}
