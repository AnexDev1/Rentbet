import 'package:flutter/material.dart';
import 'profile_utils.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryText = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
        ),
        Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              ProfileUtils.buildListTile(
                context,
                Icons.notifications_outlined,
                'Notifications',
                onTap: () {},
                iconColor: primaryText,
                textColor: primaryText,
              ),
              Divider(height: 1, indent: 56, color: theme.dividerColor),
              ProfileUtils.buildListTile(
                context,
                Icons.language_outlined,
                'Language',
                trailing: Text(
                  'English',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
                onTap: () {},
                iconColor: primaryText,
                textColor: primaryText,
              ),
              Divider(height: 1, indent: 56, color: theme.dividerColor),
              ProfileUtils.buildListTile(
                context,
                Icons.help_outline,
                'Help & Support',
                onTap: () {},
                iconColor: primaryText,
                textColor: primaryText,
              ),
              Divider(height: 1, indent: 56, color: theme.dividerColor),
              ProfileUtils.buildListTile(
                context,
                Icons.info_outline,
                'About',
                onTap: () {},
                iconColor: primaryText,
                textColor: primaryText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}