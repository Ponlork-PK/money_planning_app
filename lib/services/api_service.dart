import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final SupabaseClient client;

  Future<void> init() async {
    client = Supabase.instance.client;
  }

  // ----- AUTH -----
  GoTrueClient get auth => client.auth;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Session? get session => auth.currentSession;
  User? get user => auth.currentUser;
}
