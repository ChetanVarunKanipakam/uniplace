import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_placement_app/data/models/company_model.dart';
import '../../state/auth_provider.dart';
import '../../state/company_provider.dart';
import '../widgets/custom_button.dart'; // Ensure you have this
import '../widgets/custom_textfield.dart'; // Ensure you have this

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final cgpaCtrl = TextEditingController();
  final branchCtrl = TextEditingController();
  // final resumeCtrl = TextEditingController(); // Resume is uploaded separately for student

  String role = "student";
  String? selectedCompany;
  List<Company> companies = []; // dynamically fetched

  @override
  void initState() {
    super.initState();
    // fetch companies once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).loadCompanies();
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    cgpaCtrl.dispose();
    branchCtrl.dispose();
    // resumeCtrl.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final payload = {
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "password": passwordCtrl.text.trim(),
        "role": role,
      };

      if (role == "student") {
        payload["cgpa"] = cgpaCtrl.text.trim();
        payload["branch"] = branchCtrl.text.trim();
        // payload["resumeUrl"] = ""; // Initially empty, uploaded later
      } else if (role == "recruiter") {
        payload["company"] = selectedCompany ?? "";
      }

      await authProvider.register(payload);

      if (!mounted) return;

      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${authProvider.error}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registered successfully!", style: Theme.of(context).textTheme.labelLarge),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
        Navigator.pop(context); // back to login
      }
    }
  }

   @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);
    companies = companyProvider.companies;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Register", style: theme.appBarTheme.titleTextStyle),
        leading: IconButton( // Back button
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children
              children: [
                Text(
                  "Create Your Account",
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Join our university placement program",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Common fields
                CustomTextField(
                  controller: nameCtrl,
                  hintText: "Full Name",
                  validator: (v) => v!.isEmpty ? "Please enter your name" : null,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: emailCtrl,
                  hintText: "Email Address",
                  validator: (v) => v!.isEmpty ? "Please enter your email" : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: passwordCtrl,
                  hintText: "Password",
                  isPassword: true,
                  validator: (v) => v!.length < 6 ? "Password must be at least 6 characters" : null,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 24),

                // Corrected DropdownButtonFormField decoration usage
                DropdownButtonFormField<String>(
                  value: role,
                  decoration:const InputDecoration().applyDefaults(theme.inputDecorationTheme).copyWith( // Use copyWith on the theme for custom label
                    labelText: "Register As",
                    labelStyle: theme.inputDecorationTheme.labelStyle,
                  ),
                  items: const [
                    DropdownMenuItem(value: "student", child: Text("Student")),
                    DropdownMenuItem(value: "recruiter", child: Text("Recruiter")),
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                  ],
                  onChanged: (val) {
                    setState(() => role = val!);
                  },
                  validator: (v) => v == null || v.isEmpty ? "Please select a role" : null,
                ),
                const SizedBox(height: 20),

                // Role-specific fields
                if (role == "student") ...[
                  CustomTextField(
                    controller: cgpaCtrl,
                    hintText: "CGPA",
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return "Please enter your CGPA";
                      if (double.tryParse(v) == null) return "Invalid CGPA";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: branchCtrl,
                    hintText: "Branch (e.g., Computer Science)",
                    validator: (v) => v!.isEmpty ? "Please enter your branch" : null,
                  ),
                ],

                if (role == "recruiter") ...[
                  companyProvider.loading
                      ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
                      : DropdownButtonFormField<String>(
                          value: selectedCompany,
                          decoration: const InputDecoration().applyDefaults(theme.inputDecorationTheme).copyWith(// Use copyWith here as well
                            labelText: "Select Company",
                            labelStyle: theme.inputDecorationTheme.labelStyle,
                          ),
                          items: companies
                              .map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() => selectedCompany = val);
                          },
                          validator: (v) => v == null || v.isEmpty ? "Please select a company" : null,
                          isExpanded: true, // Make the dropdown take full width
                        ),
                ],

                const SizedBox(height: 30),

                authProvider.loading
                    ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
                    : CustomButton(
                        text: "Register Account",
                        onPressed: _registerUser,
                        icon: Icons.person_add_alt_1,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}