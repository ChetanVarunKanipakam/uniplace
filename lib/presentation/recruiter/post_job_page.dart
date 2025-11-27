import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/job_provider.dart';
import '../../state/user_provider.dart';
import '../widgets/custom_button.dart'; // Ensure CustomButton is imported
import '../widgets/custom_textfield.dart'; // Ensure CustomTextField is imported
import 'package:intl/intl.dart';
class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  String? _companyId; // Make it nullable and set in initState

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchProfile(context);
      if (!mounted) return;

      final user = userProvider.profile;
      if (user != null && user["role"] == "recruiter") {
        final companyId = user["company"];
        if (companyId != null) {
          setState(() {
            _companyId = companyId;
          });
          Provider.of<JobProvider>(context, listen: false).loadJobsByCompany(companyId);
        } else {
          // Handle case where recruiter has no company assigned
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Recruiter not assigned to a company.", style: Theme.of(context).textTheme.labelLarge),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    });
  }

  Future<void> _showAddJobDialog(BuildContext context) async {
    // Check if companyId is available before proceeding
    if (_companyId == null || _companyId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cannot post job: Company ID not found for this recruiter.", style: Theme.of(context).textTheme.labelLarge),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final theme = Theme.of(context);
    final roleCtrl = TextEditingController();
    final packageCtrl = TextEditingController();
    final cgpaCtrl = TextEditingController();
    final branchesCtrl = TextEditingController();
    final deadlineCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final skillsCtrl = TextEditingController();

    // Date picker for deadline
    DateTime? selectedDeadline;
    final DateFormat formatter = DateFormat('yyyy-MM-dd'); // For formatting date string

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        shape: theme.dialogTheme.shape,
        title: Text("Add New Job", style: theme.dialogTheme.titleTextStyle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: roleCtrl, hintText: "Job Role", keyboardType: TextInputType.text, validator: (v) => v!.isEmpty ? "Enter role" : null),
              const SizedBox(height: 12),
              CustomTextField(controller: packageCtrl, hintText: "Salary Package (e.g., 5 LPA)", keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "Enter package" : null),
              const SizedBox(height: 12),
              CustomTextField(controller: cgpaCtrl, hintText: "Eligibility CGPA", keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "Enter CGPA" : null),
              const SizedBox(height: 12),
              CustomTextField(controller: branchesCtrl, hintText: "Branches (comma separated, e.g., CSE, IT)", keyboardType: TextInputType.text, validator: (v) => v!.isEmpty ? "Enter branches" : null),
              const SizedBox(height: 12),
              // Deadline Date Picker
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDeadline ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025, 12, 31),
                    builder: (context, child) {
                      return Theme( // Apply theme to date picker
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: theme.primaryColor, // header background color
                            onPrimary: Colors.white, // header text color
                            onSurface: theme.textTheme.bodyMedium!.color!, // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: theme.primaryColor, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != selectedDeadline) {
                    setState(() { // setState for the parent widget to update deadlineCtrl
                      selectedDeadline = picked;
                      deadlineCtrl.text = formatter.format(picked);
                    });
                  }
                },
                child: AbsorbPointer( // Prevent direct typing in the text field
                  child: CustomTextField(
                    controller: deadlineCtrl,
                    hintText: "Application Deadline",
                    keyboardType: TextInputType.datetime,
                    validator: (v) => v!.isEmpty ? "Select deadline" : null,
                    icon: Icons.calendar_today, // Optional: add an icon
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(controller: descCtrl, hintText: "Job Description",  keyboardType: TextInputType.multiline, validator: (v) => v!.isEmpty ? "Enter description" : null),
              const SizedBox(height: 12),
              CustomTextField(controller: skillsCtrl, hintText: "Skills (comma separated, e.g., Flutter, Dart)", keyboardType: TextInputType.text, validator: (v) => v!.isEmpty ? "Enter skills" : null),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: theme.textButtonTheme.style?.textStyle?.resolve({})),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_companyId == null) {
                 // This case should be handled before dialog, but good to have a check
                 Navigator.pop(context);
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                     content: Text("Error: Company ID not found.", style: theme.textTheme.labelLarge),
                     backgroundColor: theme.colorScheme.error,
                   ),
                 );
                 return;
              }

              final jobData = {
                "companyId": _companyId!, // Use the state variable
                "role": roleCtrl.text.trim(),
                "package": packageCtrl.text.trim(),
                "eligibility": {
                  "cgpa": double.tryParse(cgpaCtrl.text.trim()) ?? 0.0,
                  "branches": branchesCtrl.text
                      .split(",")
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty) // Filter empty strings
                      .toList(),
                },
                "deadline": selectedDeadline?.toIso8601String(), // Use the DateTime object
                "description": descCtrl.text.trim(),
                "skillsRequired": skillsCtrl.text
                    .split(",")
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty) // Filter empty strings
                    .toList(),
              };

              // Basic validation (can be enhanced with Form widget)
              if (roleCtrl.text.isEmpty || packageCtrl.text.isEmpty || cgpaCtrl.text.isEmpty ||
                  branchesCtrl.text.isEmpty || descCtrl.text.isEmpty || skillsCtrl.text.isEmpty ||
                  selectedDeadline == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please fill all required fields.", style: theme.textTheme.labelLarge),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
                return;
              }


              final jobProvider = Provider.of<JobProvider>(context, listen: false);
              await jobProvider.addJob(jobData, context);

              if (mounted) {
                Navigator.pop(context); // Close dialog
                if (jobProvider.loading == false) {
                  jobProvider.loadJobsByCompany(_companyId!); // refresh jobs
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Job posted successfully!", style: theme.textTheme.labelLarge),
                      backgroundColor: theme.primaryColor,
                    ),
                  );
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text("Error posting job: ${jobProvider.loading}", style: theme.textTheme.labelLarge),
                       backgroundColor: theme.colorScheme.error,
                     ),
                   );
                }
              }
            },
            style: theme.elevatedButtonTheme.style, // Use themed button style
            child: const Text("Add Job"),
          ),
        ],
      ),
    );

    // Dispose controllers after dialog is dismissed
    roleCtrl.dispose();
    packageCtrl.dispose();
    cgpaCtrl.dispose();
    branchesCtrl.dispose();
    deadlineCtrl.dispose();
    descCtrl.dispose();
    skillsCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final jobProvider = Provider.of<JobProvider>(context);
    final theme = Theme.of(context);

    // Check if user profile is still loading or if companyId is not yet available
    if (userProvider.loading || _companyId == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Post Job", style: theme.appBarTheme.titleTextStyle)),
        body: Center(child: CircularProgressIndicator(color: theme.primaryColor)),
      );
    }

    final companyId = _companyId!; // Now _companyId is guaranteed to be not null

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Jobs", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
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
                      Text("No jobs posted yet.", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Click the button below to add your first job.", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobProvider.jobs.length,
                  itemBuilder: (_, i) {
                    final job = jobProvider.jobs[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: theme.cardTheme.shape,
                      elevation: theme.cardTheme.elevation,
                      color: theme.cardColor,
                      child: ListTile(
                        leading: Icon(Icons.work, color: theme.primaryColor),
                        title: Text(job.role , style: theme.textTheme.titleMedium),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Package: ${job.package}", style: theme.textTheme.bodyMedium),
                            Text("CGPA: ${job.eligibility }", style: theme.textTheme.bodySmall),
                            if (job.deadline != null)
                              Text("Deadline: ${DateFormat('yyyy-MM-dd').format(job.deadline!)}", style: theme.textTheme.bodySmall),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever, color: theme.colorScheme.error),
                          onPressed: () async {
                            // TODO: Implement delete job confirmation dialog
                            // await jobProvider.deleteJob(job["_id"], companyId); // Assuming _id is available
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Job deleted.", style: theme.textTheme.labelLarge), backgroundColor: theme.primaryColor),
                            );
                          },
                        ),
                        onTap: () {
                          // TODO: Implement job details/edit page for recruiter
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Tapped job: ${job.role}", style: theme.textTheme.labelLarge), backgroundColor: theme.primaryColor),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddJobDialog(context),
        icon: const Icon(Icons.add_business),
        label: const Text("Post New Job"),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// You'll need to add a dependency for intl if you don't have it for DateFormat
// import 'package:intl/intl.dart';