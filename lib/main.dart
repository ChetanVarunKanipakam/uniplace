import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/app_routes.dart';
import 'routes.dart';
import 'state/auth_provider.dart';
import 'state/company_provider.dart';
import 'state/test_provider.dart';
import 'state/notification_provider.dart';
import 'state/application_provider.dart';
import 'state/schedule_provider.dart';
import 'state/candidate_provider.dart';
import 'state/result_provider.dart';
import 'state/resume_provider.dart';
import 'state/job_provider.dart';
import 'state/user_provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => CompanyProvider()),
    ChangeNotifierProvider(create: (_) => TestProvider()),
    ChangeNotifierProvider(create: (_) => ScheduleProvider()),
    ChangeNotifierProvider(create: (_) => ResultProvider()),
    ChangeNotifierProvider(create: (_) => JobProvider()),
    ChangeNotifierProvider(create: (_) => ApplicationProvider()),
    ChangeNotifierProvider(create: (_) => CandidateProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => ResumeProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "University Placement App",
        theme: brightTheme, // Default bright theme
        darkTheme: darkTheme, // Dark theme
        themeMode: ThemeMode.system, // Automatically switch between themes
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
