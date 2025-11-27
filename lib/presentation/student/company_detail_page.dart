// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../data/models/company_model.dart';
// import '../../state/application_provider.dart';
// import '../../state/resume_provider.dart';

// class CompanyDetailPage extends StatelessWidget {
//   final Company company;

//   const CompanyDetailPage({super.key, required this.company});

//   @override
//   Widget build(BuildContext context) {
//     final appProvider = Provider.of<ApplicationProvider>(context);
//     final resumeProvider = Provider.of<ResumeProvider>(context);

//     Future<void> _apply() async {
//       final resumeUrl = resumeProvider.resumeUrl;

//       if (resumeUrl == null || resumeUrl.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please upload your resume first")),
//         );
//         return;
//       }

//       await appProvider.apply(context,{
//         "companyId": company.id,
//         "resumeUrl": resumeUrl,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(appProvider.statusMessage ?? "Applied")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text(company.name)),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(company.role,
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text("Package: ${company.package}"),
//             Text("Deadline: ${company.deadline?.toIso8601String() ?? 'N/A'}"),
//             const SizedBox(height: 10),
//             Text("Eligibility:",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             Text("CGPA ≥ ${company.eligibility.cgpa}"),
//             Text("Branches: ${company.eligibility.branches.join(', ')}"),
//             const Spacer(),
//             appProvider.applying
//                 ? const Center(child: CircularProgressIndicator())
//                 : SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: _apply,
//                       icon: const Icon(Icons.send),
//                       label: const Text("Apply Now"),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
