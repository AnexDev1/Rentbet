// lib/views/profile/widgets/profile_utils.dart
import 'package:flutter/material.dart';

class ProfileUtils {
  static Widget buildStatColumn(
      BuildContext context,
      IconData icon,
      String value,
      String label,
      Color primaryColor,
      Color secondaryColor,
      ) {
    return Column(
      children: [
        Icon(icon, color: primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: secondaryColor,
          ),
        ),
      ],
    );
  }

  static Widget buildListTile(
      BuildContext context,
      IconData icon,
      String title, {
        Widget? trailing,
        required VoidCallback onTap,
        Color? textColor,
        Color? iconColor,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      leading: Icon(
        icon,
        color: iconColor,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}