import 'package:flutter/material.dart';
import 'schedule_page.dart';
import 'shortlisted_page.dart';
import 'company_jobs_page.dart';

class CompanyDetailsPage extends StatelessWidget {
  final String companyId;
  final String companyName;

  const CompanyDetailsPage({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(companyName, style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDetailCard(
            context: context,
            theme: theme,
            icon: Icons.calendar_today,
            iconColor: Colors.blue.shade700,
            title: "Manage Schedules",
            subtitle: "Set up interviews and test dates",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SchedulePage(companyId: companyId),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildDetailCard(
            context: context,
            theme: theme,
            icon: Icons.playlist_add_check,
            iconColor: Colors.green.shade700,
            title: "Manage Shortlists",
            subtitle: "Select and publish final candidates",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShortlistedPage(companyId: companyId),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
           _buildDetailCard(
            context: context,
            theme: theme,
            icon: Icons.work_outline,
            iconColor: Colors.orange.shade800,
            title: "Manage Jobs",
            subtitle: "Create, view, and update job listings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // We need to pass both ID and name to this page
                  builder: (_) => CompanyJobsPage(
                    companyId: companyId,
                    companyName: companyName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: theme.cardTheme.shape,
      elevation: theme.cardTheme.elevation,
      color: theme.cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Icon(icon, color: iconColor, size: 36),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
        onTap: onTap,
      ),
    );
  }
}