// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/views/auth/auth_page.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../services/auth_service.dart';
import '../edit_profile_page.dart';
import '../createListing/create_listings_page.dart';
import 'profile_utils.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signOut();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AuthPage()));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: ${error.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final theme = Theme.of(context);
    final Color primaryText = theme.textTheme.bodyLarge?.color ?? Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Account',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
                Icons.person_outline,
                'Edit Profile',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()));
                },
                iconColor: primaryText,
                textColor: primaryText,
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: theme.dividerColor),
              ProfileUtils.buildListTile(
                context,
                Icons.favorite_outline,
                'My Wishlist',
                trailing: Text(
                  '${wishlistProvider.wishlist.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryText),
                ),
                onTap: () {},
                iconColor: primaryText,
                textColor: primaryText,
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: theme.dividerColor),
              ProfileUtils.buildListTile(
                context,
                Icons.bookmark_outline,
                'Create Listings',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateListingsPage()));
                },
                iconColor: primaryText,
                textColor: primaryText,
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: theme.dividerColor),
              ProfileUtils.buildListTile(
                context,
                Icons.settings_outlined,
                'Settings',
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