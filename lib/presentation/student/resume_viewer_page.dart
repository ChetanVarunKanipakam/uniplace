import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../state/user_provider.dart';
import '../widgets/custom_button.dart'; // Import for an upload button

class ResumeViewerPage extends StatefulWidget {
  const ResumeViewerPage({super.key});

  @override
  State<ResumeViewerPage> createState() => _ResumeViewerPageState();
}

class _ResumeViewerPageState extends State<ResumeViewerPage> {
  @override
  void initState() {
    super.initState();
    // Profile should be fetched on login/splash, but this is a good fallback.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final user = userProvider.profile;
    
    // Check if user or resumeUrl is null/empty
    if (user == null || user["resumeUrl"] == null || user["resumeUrl"].isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_upload_off, size: 80, color: theme.disabledColor),
              const SizedBox(height: 16),
              Text("No Resume Uploaded", style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text("Please go to your Profile to upload your resume.", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
               const SizedBox(height: 24),
              CustomButton(
                text: "Go to Profile",
                onPressed: () {
                  // Assuming you have a route for profile
                  Navigator.pushNamed(context, '/profile'); // Adjust route name as needed
                },
                icon: Icons.person,
              ),
            ],
          ),
        ),
      );
    }
    
    // Construct the full URL
    final pdfUrl = user["resumeUrl"];

    return Scaffold(
      // The main HomePage provides the AppBar
      // appBar: AppBar(
      //   title: Text("Your Resume", style: theme.appBarTheme.titleTextStyle),
      //   backgroundColor: theme.appBarTheme.backgroundColor,
      // ),
      body: _buildPdfViewer(pdfUrl, theme),
    );
  }

  Widget _buildPdfViewer(String pdfUrl, ThemeData theme) {
    // Use Syncfusion for Web & Desktop
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return SfPdfViewer.network(pdfUrl);
    }

    // Use flutter_cached_pdfview for Android/iOS
    return PDF().cachedFromUrl(
      pdfUrl,
      placeholder: (progress) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(value: progress / 100, color: theme.primaryColor),
            const SizedBox(height: 16),
            Text("Loading Resume... ${progress.toStringAsFixed(0)}%", style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
      errorWidget: (error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text("Error Loading PDF", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Please try uploading your resume again.", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}