import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/common/widgets/rectangular_button.dart';

class UserProfileSection extends StatelessWidget {
  final VoidCallback onMessage;

  const UserProfileSection({
    Key? key,
    required this.onMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'John Doe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Owner',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        RectangularButton(
          icon: Icons.call,
          onPressed: (){
            () async {
              // Replace with actual phone number from your data model
              const phoneNumber = '+251917413622';
              final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

              try {
                await launchUrl(phoneUri);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch phone dialer')),
                );
              }
            };
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