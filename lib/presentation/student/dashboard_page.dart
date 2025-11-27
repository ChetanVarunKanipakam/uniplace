import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/company_provider.dart';
import '../widgets/company_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
      // The main HomePage already provides an AppBar. If this is a standalone page, uncomment this.
      // appBar: AppBar(
      //   title: Text("Dashboard", style: theme.appBarTheme.titleTextStyle),
      //   backgroundColor: theme.appBarTheme.backgroundColor,
      // ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : provider.companies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business_center_sharp, size: 80, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text("No Companies Available", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        "Please check back later for placement opportunities.",
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => provider.loadCompanies(),
                  color: theme.primaryColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), // Give cards some top/bottom space
                    itemCount: provider.companies.length,
                    itemBuilder: (context, index) {
                      return CompanyCard(
                        company: provider.companies[index],
                      );
                    },
                  ),
                ),
    );
  }
}