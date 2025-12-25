import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/result_provider.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  void initState() {
    super.initState();

    // fetch results after first frame (example companyId — replace with dynamic)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResultProvider>(context, listen: false)
          .fetchResultsForStudents(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resultProvider = Provider.of<ResultProvider>(context);
    final result = resultProvider.result;
    // print(result);
    return Scaffold(
      appBar: AppBar(
        title: Text("Placement Results", style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            
            resultProvider.fetchResultsForStudents(context);
          },
          child: const Icon(Icons.refresh),
        ),

      body: resultProvider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))

          // Handle empty data
          : result == null || (result["results"] as List?)?.isEmpty == true 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events_outlined,
                          size: 80, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text("Results Are Not Out Yet",
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        "Check back once companies publish their shortlists.",
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )

          // Show results list
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: (result["results"] as List).length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = (result["results"] as List)[index];
                final bool isSelected = r["isSelected"] == true;
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.cancel,
                      color: isSelected
                          ? Colors.green.shade600
                          : theme.colorScheme.error,
                      size: 36,
                    ),
                    title: Text(
                      r["companyName"] ?? "Unknown Company",
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      isSelected
                          ? "🎉 Congrats! You are selected for the ${r['jobRole']} role."
                          : "Not selected for the ${r['role']} role.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.green.shade700
                            : theme.colorScheme.error,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
