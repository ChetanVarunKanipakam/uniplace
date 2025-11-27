import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/result_provider.dart';
import '../../state/candidate_provider.dart';
import '../widgets/custom_button.dart'; // Import your custom button for consistent styling

class ShortlistedPage extends StatefulWidget {
  final String companyId;
  const ShortlistedPage({super.key, required this.companyId});

  @override
  State<ShortlistedPage> createState() => _ShortlistedPageState();
}

class _ShortlistedPageState extends State<ShortlistedPage> {
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResultProvider>(context, listen: false).fetchResults(widget.companyId, context);
      Provider.of<CandidateProvider>(context, listen: false).loadCandidates(widget.companyId, context);
    });
  }

  void _publishResults() async {
    final theme = Theme.of(context);
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select at least one candidate to publish.", style: theme.textTheme.labelLarge),
          backgroundColor: theme.colorScheme.error,
        ),
      );
      return;
    }

    // Confirmation Dialog
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: theme.dialogTheme.shape,
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text("Confirm Publish", style: theme.dialogTheme.titleTextStyle),
        content: Text(
          "Are you sure you want to publish the results for these ${_selectedIds.length} selected candidates? This action cannot be undone.",
          style: theme.dialogTheme.contentTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: theme.elevatedButtonTheme.style,
            child: const Text("PUBLISH"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final resultProvider = Provider.of<ResultProvider>(context, listen: false);
      await resultProvider.publishResults({
        "companyId": widget.companyId,
        "selectedStudents": _selectedIds.toList(),
      }, context);

      if (!mounted) return;

      if (resultProvider.loading == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Results published successfully!", style: theme.textTheme.labelLarge),
            backgroundColor: theme.primaryColor,
          ),
        );
        setState(() {
          _selectedIds.clear(); // reset selection
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${resultProvider.loading}", style: theme.textTheme.labelLarge),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultProvider = Provider.of<ResultProvider>(context);
    final candidateProvider = Provider.of<CandidateProvider>(context);
    final theme = Theme.of(context);

    final alreadyShortlisted = (resultProvider.result?["selectedStudents"] ?? [])
        .map<String>((s) => s["_id"].toString())
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text("Shortlist Candidates", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: (resultProvider.loading || candidateProvider.loading)
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : Column(
              children: [
                if (candidateProvider.candidates.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group_off_outlined, size: 80, color: theme.disabledColor),
                          const SizedBox(height: 16),
                          Text("No candidates to shortlist", style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text("No candidates have applied for jobs at your company yet.", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      itemCount: candidateProvider.candidates.length,
                      itemBuilder: (_, i) {
                        final c = candidateProvider.candidates[i]["student"];
                        final id = c["_id"].toString();
                        final name = c["name"] ?? "Unknown";
                        final email = c["email"] ?? "No Email";
                        final isShortlisted = alreadyShortlisted.contains(id);
                        final isSelected = _selectedIds.contains(id);

                        return CheckboxListTile(
                          value: isShortlisted ? true : isSelected,
                          onChanged: isShortlisted
                              ? null // ✅ disabled if already shortlisted
                              : (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedIds.add(id);
                                    } else {
                                      _selectedIds.remove(id);
                                    }
                                  });
                                },
                          title: Text(name, style: theme.textTheme.titleMedium),
                          subtitle: Text(email, style: theme.textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: theme.primaryColor,
                          tileColor: theme.cardColor,
                          secondary: isShortlisted ? Icon(Icons.check_circle, color: Colors.green.shade600) : null,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
                    ),
                  ),
                if (candidateProvider.candidates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButton( // Using your styled CustomButton
                      text: "Publish Results for ${_selectedIds.length} Candidates",
                      onPressed: _publishResults,
                      icon: Icons.publish,
                    ),
                  ),
              ],
            ),
    );
  }
}