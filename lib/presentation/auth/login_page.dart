import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../../core/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _login() async {
  setState(() => _loading = true);
  try {
    await Provider.of<AuthProvider>(context, listen: false).login({
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
    });
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  } catch (e) {
    if (!mounted) return;
    // Display the user-friendly error message thrown from the AuthProvider.
    // We use replaceFirst to remove the "Exception: " prefix for a cleaner message.
    final errorMessage = e.toString().replaceFirst('Exception: ', '');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }
  // It's better to place this in a `finally` block to ensure it always runs.
  if (mounted) {
    setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    // Access the theme
    final theme = Theme.of(context);

    return Scaffold(
      body: Center( // Center the content vertically and horizontally
        child: SingleChildScrollView( // Allows scrolling if content is too tall
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              // University Logo/Icon (Optional)
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.school_outlined, // Or a custom image asset
                  size: 100,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Welcome Back",
                style: theme.textTheme.headlineSmall, // Using theme text style
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Sign in to continue to your account",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomTextField(hintText: "Email", controller: _emailController, keyboardType:  TextInputType.emailAddress),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: "Password",
                controller: _passwordController,
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 24),
              _loading
                  ? Center(child: CircularProgressIndicator(color: theme.primaryColor)) // Use theme color
                  : CustomButton(text: "Login", onPressed: _login),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.textButtonTheme.style?.foregroundColor?.resolve({})), // Use text button color
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}