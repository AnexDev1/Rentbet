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
              ProfileUtils.buildStatColumn(
                context,
                Icons.favorite_rounded,
                '${wishlistProvider.wishlist.length}',
                'Wishlist',
                blackPrimary,
                blackSecondary,
              ),
              ProfileUtils.buildStatColumn(
                context,
                Icons.bookmark_rounded,
                '0',
                'Bookmarks',
                blackPrimary,
                blackSecondary,
              ),
              ProfileUtils.buildStatColumn(
                context,
                Icons.history_rounded,
                '12',
                'Recent',
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