class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? defaultCurrency;
  final String? language;
  final bool? darkMode;
  final bool? notificationsEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.defaultCurrency,
    this.language,
    this.darkMode,
    this.notificationsEnabled,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'],
      phone: map['phone'],
      defaultCurrency: map['default_currency'],
      language: map['language'],
      darkMode: map['dark_mode'],
      notificationsEnabled: map['notifications_enabled'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'default_currency': defaultCurrency,
      'language': language,
      'dark_mode': darkMode,
      'notifications_enabled': notificationsEnabled,
    };
  }
}
