// core/localization/locale_controller.dart
import 'package:get/get.dart';
import 'package:money_planning_app/utils/app_languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  LocaleController(this._prefs);

  static LocaleController get to => Get.find();

  static const _storageKey = 'settings_language';
  final SharedPreferences _prefs;

  late final Rx<AppLanguages> current;

  @override
  void onInit() {
    super.onInit();
    // Synchronous: prefs were already loaded in main().
    current = AppLanguages.fromCode(_prefs.getString(_storageKey)).obs;
  }

  Future<void> changeLanguage(AppLanguages language) async {
    if (language.languageCode == current.value.languageCode) return;
    current.value = language;
    Get.updateLocale(language.locale); // real-time update for every .tr
    await _prefs.setString(_storageKey, language.languageCode);
  }

  Future<void> changeLanguageByCode(String? code) async {
    if (code == null) return;
    await changeLanguage(AppLanguages.fromCode(code));
  }
}
