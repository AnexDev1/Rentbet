// dart
import 'package:flutter/material.dart';

import '../../../models/listing_model.dart';
import '../../details/details_page.dart';

class BestForYou extends StatelessWidget {
  final List<Listing> listings;

  const BestForYou({Key? key, required this.listings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        Column(
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
                    Image.network(
                      listing.imageUrl,
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
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