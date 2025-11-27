import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/job_model.dart';
import '../../state/application_provider.dart';
import '../../state/user_provider.dart'; // Changed from ResumeProvider for more direct access
import '../widgets/custom_button.dart'; // Use your custom button

class JobDetailPage extends StatelessWidget {
  final Job job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<ApplicationProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false); // listen:false as we only need to read once
    final theme = Theme.of(context);

    Future<void> _apply() async {
      // It's better to check the profile directly from UserProvider
      final resumeUrl = userProvider.profile?['resumeUrl'];

      if (resumeUrl == null || resumeUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please upload your resume from the Profile page first.", style: theme.textTheme.labelLarge),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        return;
      }
    try {
      await appProvider.apply(context, {
        "companyId": job.companyId,
        "jobId": job.id,
        "resumeUrl": resumeUrl, // Pass the fetched resume URL
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appProvider.statusMessage ?? "Success!", style: theme.textTheme.labelLarge),
            backgroundColor: theme.primaryColor,
          ),
        );
      }
    } catch (e) {
      // If apply() throws an exception, the provider has already set the error message.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", ""), style: theme.textTheme.labelLarge),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Job Details", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.role,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              "Package: ${job.package}",
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor),
            ),
            const Divider(height: 32),
            _buildDetailSection(
              theme: theme,
              title: "Job Description",
              content: Text(job.description, style: theme.textTheme.bodyLarge),
            ),
            _buildDetailSection(
              theme: theme,
              title: "Eligibility",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(theme, Icons.score, "Minimum CGPA", job.eligibility.cgpa.toString()),
                  _buildDetailRow(theme, Icons.group_work, "Eligible Branches", job.eligibility.branches.join(", ")),
                ],
              ),
            ),
            _buildDetailSection(
              theme: theme,
              title: "Skills Required",
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.skillsRequired
                    .map((skill) => Chip(
                          label: Text(skill),
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          labelStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
                          side: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
                        ))
                    .toList(),
              ),
            ),
            if (job.deadline != null)
              _buildDetailSection(
                theme: theme,
                title: "Application Deadline",
                content: _buildDetailRow(
                  theme,
                  Icons.timer_off_outlined,
                  "Closes on",
                  // Format the date for better readability
                  MaterialLocalizations.of(context).formatFullDate(job.deadline!),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: appProvider.applying
            ? const Center(child: CircularProgressIndicator())
            : _buildApplyButton(context,_apply),
      ),
    );
  }

 Widget _buildApplyButton(BuildContext context,_apply) {

    // Condition 1: Check if the deadline has passed
    final bool isDeadlinePassed = job.deadline != null && DateTime.now().isAfter(job.deadline!);
    if (isDeadlinePassed) {
      return CustomButton(
        onPressed: (){}, // Disables the button
        icon: Icons.timer_off,
        text: "Deadline Passed",
      );
    }

    // Condition 2: Check if the user has already applied

    // Default: The user can apply
    return CustomButton(
      onPressed: _apply,
      icon: Icons.send,
      text: "Apply Now",
    );
  }
  Widget _buildDetailSection({required ThemeData theme, required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyLarge,
                children: [
                  TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}