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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Best For You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryListingsPage(category: category),
                  ),
                );
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Colors.grey),
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
                    builder: (context) => DetailsPage(property: {
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
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Price: \$${listing.price}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
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