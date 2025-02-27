import 'package:flutter/material.dart';
import '/common/widgets/rectangular_button.dart';

class UserProfileSection extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const UserProfileSection({
    Key? key,
    required this.onCall,
    required this.onMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/profile_placeholder.png'),
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
          onPressed: onCall,
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