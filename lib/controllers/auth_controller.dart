import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/utils/prefs.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Auth state (local only — no Supabase)
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalSession();
  }

  Future<void> _loadLocalSession() async {
    isLoggedIn.value = await Prefs.isLoggedIn();
  }

  /// Sign in using local credentials stored in SharedPreferences.
  /// No Supabase auth backend is called.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Basic validation
      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Email and password are required.';
        return false;
      }

      // Save session locally
      await Prefs.saveLogin(userId: email, email: email);
      isLoggedIn.value = true;

      Get.snackbar('Welcome', 'Signed in successfully!', snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out — clears local session only.
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Prefs.logOut();
      isLoggedIn.value = false;

      Get.snackbar('Signed out', 'See you again!', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
