// lib/views/profile/widgets/profile_settings_card.dart
import 'package:flutter/material.dart';
import 'profile_utils.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color blackPrimary = Color(0xDE000000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: blackPrimary,
            ),
          ),
        ),
        Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              ProfileUtils.buildListTile(
                context,
                Icons.notifications_outlined,
                'Notifications',
                onTap: () {},
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.shade200),
              ProfileUtils.buildListTile(
                context,
                Icons.language_outlined,
                'Language',
                trailing: Text(
                  'English',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                onTap: () {},
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.shade200),
              ProfileUtils.buildListTile(
                context,
                Icons.help_outline,
                'Help & Support',
                onTap: () {},
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.shade200),
              ProfileUtils.buildListTile(
                context,
                Icons.info_outline,
                'About',
                onTap: () {},
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}