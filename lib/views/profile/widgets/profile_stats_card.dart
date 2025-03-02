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
    final theme = Theme.of(context);
    final Color primaryText = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color secondaryText = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor),
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
                primaryText,
                secondaryText,
              ),
              ProfileUtils.buildStatColumn(
                context,
                Icons.home_work_rounded,
                '5',
                'Properties',
                primaryText,
                secondaryText,
              ),
              ProfileUtils.buildStatColumn(
                context,
                Icons.chat_bubble_outline,
                '20',
                'Messages',
                primaryText,
                secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}