import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/config/environment.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/services/realtime_service.dart';
import 'package:money_planning_app/utils/app_routes.dart';
import 'package:money_planning_app/utils/base_constants.dart';
import 'package:money_planning_app/utils/language.dart';
import 'package:money_planning_app/utils/prefs.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Load .env file
  await dotenv.load(fileName: '.env');

  // ✅ 2. Initialize Supabase using .env keys
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );

  // ✅ 3. Initialize API Service (Singleton - NO bindings needed)
  await ApiService().init();

  // ✅ 4. Initialize Realtime subscriptions
  RealtimeService().init();

  final loggedIn = await Prefs.isLoggedIn();

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: BaseConstants.appName,
      initialRoute: isLoggedIn ? RoutesName.home : RoutesName.login,
      getPages: getPages,
      translations: Language(),
      locale: const Locale("km"),
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // home: LoginScreen(),
    );
  }
}
