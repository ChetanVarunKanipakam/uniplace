import 'package:flutter/material.dart';
import '../../data/models/job_model.dart';
import '../student/job_detail_page.dart'; // Ensure this path is correct

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: theme.cardTheme.margin, // Use theme margin
      shape: theme.cardTheme.shape,   // Use theme shape
      elevation: theme.cardTheme.elevation, // Use theme elevation
      color: theme.cardColor, // Use theme card color
      child: InkWell(
        borderRadius: BorderRadius.circular(12), // Match card shape
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobDetailPage(job: job),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Consistent padding
          child: Row(
            children: [
              // Icon for job (optional, but adds visual appeal)
              Icon(Icons.work_outline, size: 30, color: theme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.role,
                      style: theme.textTheme.titleMedium, // Use theme for role title
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Skills: ${job.skillsRequired.join(', ')}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Salary: ${job.package}", // Assuming job model has salary
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}