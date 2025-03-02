// dart
import 'package:flutter/material.dart';
import 'package:rentbet/views/listings/category_listing_page.dart';
import '../../../models/listing_model.dart';
import '../../details/details_page.dart';
import 'best_foryou_skeleton.dart';

class BestForYou extends StatelessWidget {
  final List<Listing> listings;
  final String category;
  final bool isLoading;

  const BestForYou({
    super.key,
    required this.listings,
    required this.category,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Best For You',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryListingsPage(category: category),
                  ),
                );
              },
              child: Text(
                'See More',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
              ),
            ),
          ],
        ),
        isLoading
            ? const BestForYouSkeleton()
            : Column(
          children: listings.map((listing) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsPage(property: {
                      'imageUrl': listing.imageUrl,
                      'price': '\$${listing.price}',
                      'location': listing.location,
                      'title': listing.title,
                      'desc': listing.description,
                      'category': listing.category,
                      'type': listing.type,
                    }),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        listing.imageUrl,
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Property at ${listing.location}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Price: \$${listing.price}',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}