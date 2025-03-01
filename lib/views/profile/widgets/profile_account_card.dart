// lib/views/profile/widgets/profile_account_card.dart
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

      // Navigate to auth page and clear navigation stack
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> AuthPage())
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: ${error.toString()}')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    const Color blackPrimary = Color(0xDE000000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Account',
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
              // Update the onTap for Edit Profile in ProfileAccountCard
              ProfileUtils.buildListTile(
                context,
                Icons.person_outline,
                'Edit Profile',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilePage())
                  );
                },
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.shade200),
              ProfileUtils.buildListTile(
                context,
                Icons.favorite_outline,
                'My Wishlist',
                trailing: Text(
                  '${wishlistProvider.wishlist.length}',
                  style: const TextStyle(
                    color: blackPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.shade200),
              ProfileUtils.buildListTile(
                context,
                Icons.bookmark_outline,
                'Create Listings',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateListingsPage())
                  );
                },
                iconColor: blackPrimary,
                textColor: blackPrimary,
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.shade200),
              ProfileUtils.buildListTile(
                context,
                Icons.settings_outlined,
                'Settings',
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