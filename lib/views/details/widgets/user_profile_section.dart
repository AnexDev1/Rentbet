import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/common/widgets/rectangular_button.dart';

class UserProfileSection extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? userImageUrl;
  final VoidCallback onMessage;
  final String? phoneNumber;

  const UserProfileSection({
    Key? key,
    required this.onMessage,
    this.userName = 'Unknown User',
    this.userRole = 'Owner',
    this.userImageUrl,
    this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: userImageUrl != null
              ? NetworkImage(userImageUrl!)
              : const AssetImage('assets/logo.png') as ImageProvider,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              userRole,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        RectangularButton(
          icon: Icons.call,
          onPressed: () async {
            final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber ?? '+251917413622');
            try {
              await launchUrl(phoneUri);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch phone dialer')),
                );
              }
            }
          },
        ),
        const SizedBox(width: 8),
        RectangularButton(
          icon: Icons.message,
          onPressed: onMessage,
        ),
      ],
    );
  }
}