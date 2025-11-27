import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator; // Added validator
  final TextInputType? keyboardType; // Added keyboardType
  final IconData? icon; // Add this line

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.icon, // Initialize it
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    InputDecoration effectiveDecoration = const InputDecoration().applyDefaults(theme.inputDecorationTheme).copyWith(
      hintText: widget.hintText,
      prefixIcon: widget.icon != null ? Icon(widget.icon, color: theme.iconTheme.color?.withOpacity(0.6)) : null, // Add prefixIcon
      suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: theme.iconTheme.color?.withOpacity(0.6),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );

    return TextFormField( // Changed from TextField to TextFormField for validator support
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      style: theme.textTheme.bodyLarge, // Apply text style from theme
      decoration: effectiveDecoration,
    );
  }
}