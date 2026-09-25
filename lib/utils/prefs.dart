import 'package:money_planning_app/utils/base_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // Save login
  static Future<void> saveLogin({required String userId, required String email})async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(BaseConstants.prefIsLoggedIn, true);
    await prefs.setString(BaseConstants.prefUserId, userId);
    await prefs.setString(BaseConstants.prefEmail, email);
  }

  // Check login
  static Future<bool> isLoggedIn()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(BaseConstants.prefIsLoggedIn) ?? false;
  }

  // Get stored data
  static Future<String?> getUserId()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(BaseConstants.prefUserId);
  }

  // Get email
  static Future<String?> getEmail()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(BaseConstants.prefEmail);
  }

  static Future<void> logOut()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(BaseConstants.prefIsLoggedIn);
    await prefs.remove(BaseConstants.prefUserId);
    await prefs.remove(BaseConstants.prefEmail);
  }
}