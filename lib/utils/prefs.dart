import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _isLoggedIn = "is_logged_in";
  static const _userId = "user_id";
  static const _email = "email";

  // Save login
  static Future<void> saveLogin({required String userId, required String email})async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, true);
    await prefs.setString(_userId, userId);
    await prefs.setString(_email, email);
  }

  // Check login
  static Future<bool> isLoggedIn()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  // Get stored data
  static Future<String?> getUserId()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId);
  }

  // Get email
  static Future<String?> getEmail()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  static Future<void> logOut()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedIn);
    await prefs.remove(_userId);
    await prefs.remove(_email);
  }
}