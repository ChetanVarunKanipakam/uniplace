import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening resume URLs
import '../../state/candidate_provider.dart';

class CandidatesPage extends StatefulWidget {
  final String jobId;
  const CandidatesPage({super.key, required this.jobId});

  @override
  State<CandidatesPage> createState() => _CandidatesPageState();
}
class _CandidatesPageState extends State<CandidatesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CandidateProvider>(context, listen: false).loadCandidates(widget.jobId, context);
    });
  }

  Future<void> _launchURL(String urlString, BuildContext context) async {
    final theme = Theme.of(context);
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open resume', style: theme.textTheme.labelLarge),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final candidateProvider = Provider.of<CandidateProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Applied Candidates", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: candidateProvider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : candidateProvider.candidates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search_outlined, size: 80, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text("No candidates have applied yet.", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Check back later for new applications.", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: candidateProvider.candidates.length,
                  itemBuilder: (_, i) {
                    final c = candidateProvider.candidates[i];
                    final student = c["student"];

                    if (student == null) {
                      return Card(
                        margin: EdgeInsets.zero,
                        shape: theme.cardTheme.shape,
                        elevation: theme.cardTheme.elevation,
                        child: ListTile(
                          leading: Icon(Icons.person_off_outlined, color: theme.colorScheme.error),
                          title: Text("Unknown Candidate Data", style: theme.textTheme.titleMedium),
                        ),
                      );
                    }

                    return Card(
                      margin: EdgeInsets.zero,
                      shape: theme.cardTheme.shape,
                      elevation: theme.cardTheme.elevation,
                      color: theme.cardColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Icon(Icons.person, color: theme.primaryColor),
                        ),
                        title: Text(student["name"] ?? "No name", style: theme.textTheme.titleMedium),
                        subtitle: Text(
                          "CGPA: ${student["cgpa"]?.toString() ?? "N/A"} • Branch: ${student["branch"] ?? "N/A"}",
                          style: theme.textTheme.bodyMedium,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.download_for_offline, color: theme.primaryColor),
                          tooltip: "Download Resume",
                          onPressed: () {
                            final url = student["resumeUrl"];
                            if (url != null && url.isNotEmpty) {
                              _launchURL(url, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("No resume has been uploaded by this candidate.", style: theme.textTheme.labelLarge),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                ),
    );
  }
}