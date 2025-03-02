import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/views/home/home_page.dart';

import '../../models/wishlist_model.dart';
import '../../providers/wishlist_provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isLightTheme
            ? theme.scaffoldBackgroundColor
            : (theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor),
        elevation: 0.5,
        centerTitle: false,
        title: Text(
          'My Wishlist',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: isLightTheme ? Colors.black : (theme.appBarTheme.foregroundColor ?? theme.primaryColor),
          ),
        ),
        actions: [
          if (wishlist.isNotEmpty)
            IconButton(
              icon: Icon(Icons.sort, color: isLightTheme ? Colors.black : theme.iconTheme.color),
              onPressed: () {
                // Sort functionality
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (wishlist.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Saved Properties',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.hintColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${wishlist.length} items',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: wishlist.isEmpty
                ? _buildEmptyState(theme)
                : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final listing = wishlist[index];
                  return _buildWishlistCard(context, listing, theme);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard(BuildContext context, WishlistItem item, ThemeData theme) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to details if needed
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.dividerColor,
                          child:
                          Icon(Icons.image_not_supported, size: 40, color: theme.iconTheme.color),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.cardColor,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.bookmark, color: theme.iconTheme.color),
                        iconSize: 20,
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 36,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Provider.of<WishlistProvider>(context, listen: false)
                              .removeFromWishlist(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Removed from wishlist'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: theme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${item.price}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.location,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: theme.dividerColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved properties',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Properties you like will appear here',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Explore Properties', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}