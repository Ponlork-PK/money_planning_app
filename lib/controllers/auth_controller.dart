import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/prefs.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Auth state
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalSession();
  }

  Future<void> _loadLocalSession() async {
    isLoggedIn.value = await Prefs.isLoggedIn();
  }

  /// Sign in via Supabase — validates credentials against real users.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Basic client-side validation
      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Email and password are required.';
        return false;
      }

      // ✅ Authenticate with Supabase
      final response = await ApiService().signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        errorMessage.value = 'Login failed. Please check your credentials.';
        return false;
      }

      // ✅ Save session locally
      await Prefs.saveLogin(
        userId: response.user!.id,
        email: response.user!.email ?? email,
      );
      isLoggedIn.value = true;

      return true;
    } on Exception catch (e) {
      // Parse Supabase error messages into user-friendly text
      final raw = e.toString();
      if (raw.contains('Invalid login credentials') ||
          raw.contains('invalid_credentials')) {
        errorMessage.value = 'Incorrect email or password.';
      } else if (raw.contains('Email not confirmed')) {
        errorMessage.value = 'Please confirm your email before logging in.';
      } else if (raw.contains('too many requests') ||
          raw.contains('rate limit')) {
        errorMessage.value = 'Too many attempts. Please try again later.';
      } else {
        errorMessage.value = 'Login failed. Please try again.';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out — clears Supabase session and local storage.
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // ✅ Sign out from Supabase
      await ApiService().signOut();

      // ✅ Clear local session
      await Prefs.logOut();
      isLoggedIn.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
