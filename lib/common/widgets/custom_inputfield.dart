import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  OutlineInputBorder _buildInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final borderColor = theme.dividerColor;

    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: textColor)
            : null,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: textColor),
        border: _buildInputBorder(borderColor),
        enabledBorder: _buildInputBorder(borderColor),
        focusedBorder: _buildInputBorder(theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}