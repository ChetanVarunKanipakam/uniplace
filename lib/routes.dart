import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/register_page.dart';
import 'presentation/auth/profile_page.dart';
import 'presentation/common/splash_page.dart';
import 'presentation/common/home_page.dart';
import 'presentation/common/notification_page.dart';

// Student
import 'presentation/student/dashboard_page.dart';
import 'presentation/student/resume_viewer_page.dart';
import 'presentation/student/test_page.dart';
import 'presentation/student/results_page.dart';

// Admin
import 'presentation/admin/manage_companies_page.dart';

// Recruiter
import 'presentation/recruiter/post_job_page.dart';
import 'presentation/recruiter/company_jobs_page.dart';
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      // Student
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case AppRoutes.resume:
        return MaterialPageRoute(builder: (_) => const ResumeViewerPage());
      case AppRoutes.test:
        return MaterialPageRoute(builder: (_) => const TestPage());
      case AppRoutes.results:
        return MaterialPageRoute(builder: (_) => const ResultsPage());

      // Admin
      case AppRoutes.manageCompanies:
        return MaterialPageRoute(builder: (_) => const ManageCompaniesPage());

      // Recruiter
      case AppRoutes.postJob:
        return MaterialPageRoute(builder: (_) => const PostJobPage());
      case AppRoutes.candidates:
        return MaterialPageRoute(builder: (_) => const CompanyJobsPage());

      // Common
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}
