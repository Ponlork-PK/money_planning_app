import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/screens/login/login_screen.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/app_routes.dart';
import 'package:money_planning_app/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 2. Initialize Supabase
  await Supabase.initialize(
    url: 'https://kcdjqiyhonafumfodmky.supabase.co',
    anonKey: 'sb_publishable_YMsj0qSQ2qpdfpxBkgOY_Q_t8Au_VZe',
  );

  // ✅ 3. Initialize API Service (Singleton - NO bindings needed)
  await ApiService().init();

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
