import 'package:flutter/material.dart';
import '../../data/models/company_model.dart';
import '../student/company_jobs_page.dart';

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Material(
        color: theme.colorScheme.surface,
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        shadowColor: theme.shadowColor.withOpacity(0.15),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompanyJobsPage(company: company),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ Image Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: company.photoUrl.isNotEmpty
                    ? Image.network(
                        company.photoUrl,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _defaultImage(theme),
                      )
                    : _defaultImage(theme),
              ),

              // 📄 Text Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultImage(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 160,
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.business_rounded,
        size: 50,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
