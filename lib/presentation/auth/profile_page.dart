import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../state/user_provider.dart';
import '../../state/auth_provider.dart';
import '../../core/app_routes.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile(context);
    });
  }

  Future<void> _pickAndUploadResume(UserProvider userProvider) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );
    if (result != null && result.files.single.path != null) {
      if (!mounted) return;
      await userProvider.uploadResume(result.files.single.path!, context);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Resume uploaded successfully!",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);
    final user = userProvider.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: theme.appBarTheme.titleTextStyle),
        elevation: 0,
      ),
      body: userProvider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : user == null
              ? _buildEmptyState(theme)
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 🔵 Profile Header with background gradient
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.9),
                              theme.colorScheme.primary.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor:
                                  theme.colorScheme.onPrimary.withOpacity(0.1),
                              child: Icon(Icons.person,
                                  size: 70, color: theme.colorScheme.onPrimary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user["name"] ?? "N/A",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${user["branch"] ?? "N/A"} • CGPA ${user["cgpa"] ?? "-"}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🧾 Profile Info Card
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Contact Information",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(thickness: 0.8),
                                const SizedBox(height: 8),
                                _buildProfileDetailRow(
                                  context,
                                  Icons.email_outlined,
                                  "Email",
                                  user["email"] ?? "N/A",
                                ),
                                _buildProfileDetailRow(
                                  context,
                                  Icons.phone_outlined,
                                  "Phone",
                                  user["phone"] ?? "Not provided",
                                ),
                                _buildProfileDetailRow(
                                  context,
                                  Icons.badge_outlined,
                                  "Role",
                                  user["role"] ?? "N/A",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 🧩 Buttons Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            CustomButton(
                              text: "Upload / Update Resume",
                              onPressed: () =>
                                  _pickAndUploadResume(userProvider),
                              icon: Icons.upload_file,
                            ),
                            const SizedBox(height: 14),
                            CustomButton(
                              text: "Logout",
                              onPressed: () {
                                authProvider.logout();
                                userProvider.clearProfile();
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.login);
                              },
                              isPrimary: false,
                              icon: Icons.logout,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: theme.colorScheme.primary.withOpacity(0.9), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color:
                        theme.colorScheme.onSurfaceVariant.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 90, color: theme.disabledColor),
          const SizedBox(height: 20),
          Text("No profile found", style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text("Please try again later or contact support.",
              style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
