import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/config/environment.dart';
import 'package:money_planning_app/controllers/login_controller.dart';
import 'package:money_planning_app/firebase_options.dart';
import 'package:money_planning_app/screens/login/login_screen.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/app_routes.dart';
import 'package:money_planning_app/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ 1. Load environment variables
  await dotenv.load(fileName: '.env');

  // ✅ 2. Initialize Supabase
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );

  // ✅ 3. Initialize API Service (Singleton - NO bindings needed)
  await ApiService().init();

  Get.put(LoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Planning App',
      initialRoute: "/login",
      getPages: getPages,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: LoginScreen(),
    );
  }
}
