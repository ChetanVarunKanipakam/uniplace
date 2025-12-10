import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
// If you want to open URLs in browser, uncomment and add url_launcher to pubspec.yaml
// import 'package:url_launcher/url_launcher.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // Dummy tests list – replace URLs with your actual test links
  final List<Map<String, String>> _tests = [
    {
      "title": "Aptitude Test 1",
      "subtitle": "30 questions · 30 mins",
      "url": "https://your-backend.com/tests/aptitude-1",
    },
    {
      "title": "Coding Test - Arrays",
      "subtitle": "20 questions · 45 mins",
      "url": "https://your-backend.com/tests/coding-arrays",
    },
    {
      "title": "DBMS & SQL Test",
      "subtitle": "25 questions · 40 mins",
      "url": "https://your-backend.com/tests/dbms-sql",
    },
  ];

  // Optional: open URL in browser
  // Future<void> _openTestUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Could not open test URL')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Tests")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _tests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final test = _tests[index];

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test["title"] ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (test["subtitle"] != null)
                    Text(
                      test["subtitle"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    test["url"] ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: "Open Test",
                      onPressed: () {
                        // If using url_launcher:
                        // _openTestUrl(test["url"]!);

                        // For now, just print or handle navigation as needed
                        // e.g., Navigator.push to a WebView page
                        debugPrint("Open: ${test["url"]}");
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
