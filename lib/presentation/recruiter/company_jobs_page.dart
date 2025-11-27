import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_placement_app/presentation/recruiter/candidates_page.dart';
import '../../data/models/job_model.dart';
import '../../state/job_provider.dart';
import '../../state/user_provider.dart';
import '../admin/shortlisted_page.dart'; // Import ShortlistedPage

class CompanyJobsPage extends StatefulWidget {
  const CompanyJobsPage({
    super.key,
  });

  @override
  State<CompanyJobsPage> createState() => _CompanyJobsPageState();
}

class _CompanyJobsPageState extends State<CompanyJobsPage> {
  String? _companyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // No need to call fetchProfile here if it's already loaded during login/splash
      // await userProvider.fetchProfile(context);

      final user = userProvider.profile;
      if (user != null && user["role"] == "recruiter") {
        final companyId = user["company"];
        if (companyId != null) {
          setState(() {
            _companyId = companyId;
          });
          Provider.of<JobProvider>(context, listen: false).loadJobsByCompany(companyId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Posted Jobs", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        actions: [
          if (_companyId != null)
            IconButton(
              icon: Icon(Icons.playlist_add_check, color: theme.appBarTheme.foregroundColor),
              tooltip: 'Shortlist Candidates',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShortlistedPage(companyId: _companyId!),
                  ),
                );
              },
            ),
        ],
      ),
      body: jobProvider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : jobProvider.jobs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_off_outlined, size: 80, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text("You haven't posted any jobs.", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Go to the 'Post Job' tab to create a new listing.", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: jobProvider.jobs.length,
                  itemBuilder: (_, i) {
                    final Job job = jobProvider.jobs[i];
                    return Card(
                      margin: EdgeInsets.zero,
                      shape: theme.cardTheme.shape,
                      elevation: theme.cardTheme.elevation,
                      color: theme.cardColor,
                      child: ListTile(
                        leading: Icon(Icons.work_outline, color: theme.primaryColor, size: 30),
                        title: Text(job.role, style: theme.textTheme.titleMedium),
                        subtitle: Text("Package: ${job.package}", style: theme.textTheme.bodyMedium),
                        trailing:
                              IconButton(
                                icon: Icon(Icons.playlist_add_check, color: theme.appBarTheme.foregroundColor),
                                tooltip: 'Shortlist Candidates',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ShortlistedPage(companyId: job.id),
                                    ),
                                  );
                                },
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CandidatesPage(jobId: job.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                ),
    );
  }
}