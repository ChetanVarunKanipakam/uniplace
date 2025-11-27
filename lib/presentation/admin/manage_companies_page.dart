import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/company_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart'; // Import CustomTextField
import 'company_details_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ManageCompaniesPage extends StatefulWidget {
  const ManageCompaniesPage({super.key});

  @override
  State<ManageCompaniesPage> createState() => _ManageCompaniesPageState();
}

class _ManageCompaniesPageState extends State<ManageCompaniesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).loadCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Companies", style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business),
        label: const Text("Add Company"),
        onPressed: () => _showAddCompanyDialog(context, provider),
      ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : provider.companies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business_center_sharp, size: 80, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text("No companies found.", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Add your first company to get started.", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.companies.length,
                  itemBuilder: (context, index) {
                    final c = provider.companies[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      shape: theme.cardTheme.shape,
                      elevation: theme.cardTheme.elevation,
                      color: theme.cardColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Icon(Icons.business, color: theme.primaryColor),
                        ),
                        title: Text(c.name, style: theme.textTheme.titleMedium),
                        subtitle: Text(c.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompanyDetailsPage(companyId: c.id, companyName: c.name),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever, color: theme.colorScheme.error),
                          tooltip: "Delete Company",
                          onPressed: () async {
                            // Confirmation Dialog
                             final bool? confirm = await showDialog(
                               context: context,
                               builder: (context) => AlertDialog(
                                 shape: theme.dialogTheme.shape,
                                 title: Text("Confirm Deletion", style: theme.dialogTheme.titleTextStyle),
                                 content: Text("Are you sure you want to delete ${c.name}? This action cannot be undone.", style: theme.dialogTheme.contentTextStyle),
                                 actions: [
                                   TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("CANCEL")),
                                   ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("DELETE"),
                                   ),
                                 ],
                               ),
                             );
                             if (confirm == true) {
                                provider.deleteCompany(c.id, context);
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




void _showAddCompanyDialog(BuildContext context, CompanyProvider provider) {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final theme = Theme.of(context);
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
    }
  }

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        shape: theme.dialogTheme.shape,
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text("Add New Company", style: theme.dialogTheme.titleTextStyle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: nameCtrl, hintText: "Company Name"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  await pickImage();
                  setState(() {}); // refresh UI
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: selectedImage == null
                      ? const Center(child: Text("Tap to pick company logo"))
                      : Image.file(selectedImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(controller: descCtrl, hintText: "Description"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CustomButton(
            text: "Add Company",
            onPressed: () async {
              if (nameCtrl.text.isEmpty || descCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Name and Description are required.",
                      style: theme.textTheme.labelLarge,
                    ),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
                return;
              }

              String photoUrl = "";
              if (selectedImage != null) {
                photoUrl = await provider.uploadImage(selectedImage!,context);
              }

              await provider.addCompany({
                "name": nameCtrl.text.trim(),
                "photoUrl": photoUrl,
                "description": descCtrl.text.trim(),
              }, context);

              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}