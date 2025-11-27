import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/company_model.dart';
import '../../data/models/job_model.dart';
import '../../state/job_provider.dart';
import '../widgets/job_card.dart';

class CompanyJobsPage extends StatefulWidget {
  final Company company;

  const CompanyJobsPage({super.key, required this.company});

  @override
  State<CompanyJobsPage> createState() => _CompanyJobsPageState();
}

class _CompanyJobsPageState extends State<CompanyJobsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).loadJobsByCompany(widget.company.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company.name, style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
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
                      Text("No Jobs Posted", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        "${widget.company.name} has not posted any jobs yet.",
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: jobProvider.jobs.length,
                  itemBuilder: (_, i) {
                    final Job job = jobProvider.jobs[i];
                    return JobCard(job: job);
                  },
                ),
    );
  }
}