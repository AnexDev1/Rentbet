import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/common/widgets/rectangular_button.dart';
import '/models/user_model.dart';
import '/services/user_service.dart';

class UserProfileSection extends StatefulWidget {
  final Map<String, String> property;
  final String userRole;
  final VoidCallback onMessage;

  const UserProfileSection({
    Key? key,
    required this.property,
    this.userRole = 'Owner',
    required this.onMessage,
  }) : super(key: key);

  @override
  State<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  bool _isLoading = true;
  Users? _propertyOwner;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPropertyOwner();
  }

  Future<void> _loadPropertyOwner() async {
    try {
      setState(() => _isLoading = true);

      // Extract user ID from property data
      final userId = widget.property['userId'];
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found in property data');
      }

      final userService = UserService();
      final user = await userService.getUserById(userId);

      if (mounted) {
        setState(() {
          _propertyOwner = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load user data';
          _isLoading = false;
        });
      }
      print('Error loading property owner: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Center(child: Text(_error!, style: TextStyle(color: Colors.red)));
    }

    final userName = _propertyOwner?.username ?? 'Unknown User';
    final userImageUrl = _propertyOwner?.profileImage;
    final phoneNumber =  '+251917413622';
    // _propertyOwner?.phoneNumber ??
    return Row(
      children: [
        CircleAvatar(
          key: ValueKey(userImageUrl ?? 'default'),
          radius: 24,
          backgroundImage: userImageUrl != null && userImageUrl.isNotEmpty
              ? NetworkImage(userImageUrl)
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
              widget.userRole,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        RectangularButton(
          icon: Icons.call,
          onPressed: () async {
            final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
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
          onPressed: widget.onMessage,
        ),
      ],
    );
  }
}