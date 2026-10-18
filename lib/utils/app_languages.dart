// core/localization/app_language.dart
import 'dart:ui';

class AppLanguages {
  const AppLanguages({
    required this.name,
    required this.languageCode,
    required this.countryCode,
  });

  final String name;
  final String languageCode;
  final String countryCode;

  Locale get locale => Locale(languageCode, countryCode);

  static const english =
      AppLanguages(name: 'English', languageCode: 'en', countryCode: 'US');
  static const khmer =
      AppLanguages(name: 'ខ្មែរ', languageCode: 'km', countryCode: 'KH');

  static const supported = [english, khmer];

  static AppLanguages fromCode(String? code) => supported.firstWhere(
        (l) => l.languageCode == code,
        orElse: () => english,
      );
}
