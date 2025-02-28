// lib/views/profile/widgets/profile_stats_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/wishlist_provider.dart';
import 'profile_utils.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    // Black with different opacities
    const Color blackPrimary = Color(0xDE000000); // 87% opacity black
    const Color blackSecondary = Color(0x8A000000); // 54% opacity black

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Wishlist using provider data
              ProfileUtils.buildStatColumn(
                context,
                Icons.favorite_rounded,
                '${wishlistProvider.wishlist.length}',
                'Wishlist',
                blackPrimary,
                blackSecondary,
              ),
              // Properties with dummy data
              ProfileUtils.buildStatColumn(
                context,
                Icons.home_work_rounded,
                '5', // dummy data
                'Properties',
                blackPrimary,
                blackSecondary,
              ),
              // Messages with dummy data
              ProfileUtils.buildStatColumn(
                context,
                Icons.chat_bubble_outline,
                '20', // dummy data
                'Messages',
                blackPrimary,
                blackSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}