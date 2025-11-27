import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';
import '../../core/app_routes.dart';

// ✅ Import your real pages
import '../student/dashboard_page.dart';
import '../student/resume_viewer_page.dart';
import '../student/test_page.dart';
import '../student/results_page.dart';
import '../admin/manage_companies_page.dart';
import '../recruiter/post_job_page.dart';
import '../recruiter/company_jobs_page.dart'; // Make sure this is imported

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final role = auth.user?["role"] ?? "student";
    final theme = Theme.of(context);

    // ✅ role-specific bottom nav items + pages
    late final List<_RoleNavItem> navItems;
    if (role == "student") {
      navItems = [
        _RoleNavItem("Dashboard", Icons.dashboard, const DashboardPage()),
        _RoleNavItem("Resume", Icons.upload_file, const ResumeViewerPage()),
        _RoleNavItem("Tests", Icons.assignment, const TestPage()),
        _RoleNavItem("Results", Icons.emoji_events, const ResultsPage()),
      ];
    } else if (role == "admin") {
      navItems = [
        _RoleNavItem("Companies", Icons.business, const ManageCompaniesPage()),
      ];
    } else if (role == "recruiter") {
      navItems = [
        _RoleNavItem("Post Job", Icons.add_business, const PostJobPage()),
        _RoleNavItem("Candidates", Icons.people_alt, const CompanyJobsPage()),
      ];
    } else {
      navItems = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome ${auth.user?["name"] ?? ""}",
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: theme.appBarTheme.elevation,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder( // DrawerTheme does not have 'shape', so revert to direct shape for now
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [theme.primaryColor, theme.colorScheme.secondary]), // Using theme colors
              ),
              accountName: Text(auth.user?["name"] ?? "User", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
              accountEmail: Text(auth.user?["email"] ?? "", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: theme.primaryColor),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: theme.iconTheme.color),
              title: Text("Notifications", style: theme.textTheme.bodyLarge),
              onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
            ),
            ListTile(
              leading: Icon(Icons.person, color: theme.iconTheme.color),
              title: Text("Profile", style: theme.textTheme.bodyLarge),
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            ),
            const Spacer(),
            Divider(color: theme.dividerColor), // Use theme divider color
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent), // Highlight logout
              title: Text("Logout", style: theme.textTheme.bodyLarge?.copyWith(color: Colors.redAccent)),
              onTap: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
            const SizedBox(height: 16), // Bottom padding for drawer
          ],
        ),
      ),
      body: navItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, size: 80, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text("No features available for your role.", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text("Please contact an administrator if you believe this is an error.", style: theme.textTheme.bodyMedium),
                ],
              ),
            )
          : navItems[_selectedIndex].page,
      bottomNavigationBar: navItems.length <= 1
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
              backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
              type: BottomNavigationBarType.fixed, // ensures all items are visible
              selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
              unselectedLabelStyle: theme.bottomNavigationBarTheme.unselectedLabelStyle,
              onTap: (i) => setState(() => _selectedIndex = i),
              items: navItems
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        label: item.label,
                      ))
                  .toList(),
            ),
    );
  }
}

class _RoleNavItem {
  final String label;
  final IconData icon;
  final Widget page;

  _RoleNavItem(this.label, this.icon, this.page);
}