import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _api = ApiService();

  // UI state
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Auth state
  final Rxn<Session> session = Rxn<Session>();
  final Rxn<User> user = Rxn<User>();

  StreamSubscription<AuthState>? _sub;

  bool get isLoggedIn => session.value != null;

  @override
  void onInit() {
    super.onInit();

    // Load initial session
    session.value = _api.session;
    user.value = _api.user;

    // Listen for auth changes
    _sub = _api.client.auth.onAuthStateChange.listen((data) {
      session.value = data.session;
      user.value = data.session?.user;
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _api.signUp(email: email, password: password);

      // Note: depending on your Supabase email confirmation setting,
      // session may be null until user confirms email.
      session.value = res.session ?? _api.session;
      user.value = res.user ?? _api.user;

      if (session.value == null) {
        // Often happens if email confirmation is ON
        Get.snackbar(
          'Check your email',
          'Confirm your email address to complete sign up.',
        );
      } else {
        Get.snackbar('Success', 'Account created!');
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Auth Error', e.message);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final res = await _api.signIn(email: email, password: password);

      session.value = res.session;
      user.value = res.user;

      Get.snackbar('Welcome', 'Signed in successfully!');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Auth Error', e.message);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _api.signOut();
      session.value = null;
      user.value = null;

      Get.snackbar('Signed out', 'See you again!');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
