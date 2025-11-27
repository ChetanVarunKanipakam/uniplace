import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_placement_app/presentation/admin/shortlisted_page.dart';
import '../../data/models/job_model.dart';
import '../../state/job_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:intl/intl.dart'; // For date formatting

class CompanyJobsPage extends StatefulWidget {
  final String companyId;
  final String companyName;

  const CompanyJobsPage({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<CompanyJobsPage> createState() => _CompanyJobsPageState();
}

class _CompanyJobsPageState extends State<CompanyJobsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).loadJobsByCompany(widget.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.companyName} Jobs", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        tooltip: "Add New Job",
        onPressed: () => _showAddJobDialog(context),
        child: const Icon(Icons.add),
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
                      Text("No jobs posted for this company.", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Add a job to get started.", style: theme.textTheme.bodyMedium),
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
                        leading: Icon(Icons.work_outline, color: theme.primaryColor),
                        title: Text(job.role, style: theme.textTheme.titleMedium),
                        subtitle: Text("Package: ${job.package}", style: theme.textTheme.bodyMedium),
                        trailing: TextButton(onPressed:()=> {Navigator.push(context, MaterialPageRoute(
                              builder: (_) =>  ShortlistedPage(companyId: job.id))
                            )}, child: Text("View Details")),
                        onTap: () => _showJobDetailsDialog(context, job),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                ),
    );
  }

  // Uses the same logic as the recruiter's 'PostJobPage' dialog
  void _showAddJobDialog(BuildContext context) {
     // This is almost identical to the dialog in recruiter/PostJobPage.dart
     // For a real app, you would extract this dialog into its own reusable widget
     // to avoid code duplication. For now, we'll style it here.
    final theme = Theme.of(context);
    final roleCtrl = TextEditingController();
    final packageCtrl = TextEditingController();
    final cgpaCtrl = TextEditingController();
    final branchesCtrl = TextEditingController();
    final deadlineCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final skillsCtrl = TextEditingController();
    DateTime? selectedDeadline;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: theme.dialogTheme.shape,
        title: Text("Add New Job", style: theme.dialogTheme.titleTextStyle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: roleCtrl, hintText: "Job Role"),
              const SizedBox(height: 12),
              CustomTextField(controller: packageCtrl, hintText: "Salary Package", keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              CustomTextField(controller: cgpaCtrl, hintText: "Eligibility CGPA", keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              CustomTextField(controller: branchesCtrl, hintText: "Branches (comma separated)"),
              const SizedBox(height: 12),
              // Deadline Picker
               GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2026));
                  if (picked != null) {
                      selectedDeadline = picked;
                      deadlineCtrl.text = formatter.format(picked);
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(controller: deadlineCtrl, hintText: "Application Deadline", icon: Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(controller: descCtrl, hintText: "Job Description"),
               const SizedBox(height: 12),
              CustomTextField(controller: skillsCtrl, hintText: "Skills (comma separated)"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          CustomButton(
            text: "Add Job",
            onPressed: () async {
              final jobData = {
                "companyId": widget.companyId,
                "role": roleCtrl.text.trim(), "package": packageCtrl.text.trim(),
                "eligibility": {"cgpa": double.tryParse(cgpaCtrl.text.trim()) ?? 0, "branches": branchesCtrl.text.split(",").map((e) => e.trim()).toList()},
                "deadline": selectedDeadline?.toIso8601String(),
                "description": descCtrl.text.trim(),
                "skillsRequired": skillsCtrl.text.split(",").map((e) => e.trim()).toList(),
              };

              await Provider.of<JobProvider>(context, listen: false).addJob(jobData, context);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showJobDetailsDialog(BuildContext context, Job job) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: theme.dialogTheme.shape,
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text(job.role, style: theme.dialogTheme.titleTextStyle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              _buildDetailRow(theme, Icons.business_center, "Package", job.package),
              _buildDetailRow(theme, Icons.score, "Min CGPA", job.eligibility.cgpa.toString()),
              _buildDetailRow(theme, Icons.group_work, "Branches", job.eligibility.branches.join(", ")),
              if (job.deadline != null)
                _buildDetailRow(theme, Icons.timer_off, "Deadline", DateFormat.yMMMd().format(job.deadline!)),
              const Divider(height: 24),
              Text("Description", style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(job.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text("Skills Required", style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(job.skillsRequired.join(", "), style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
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
          Icon(icon, size: 18, color: theme.primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text("$label: ", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}