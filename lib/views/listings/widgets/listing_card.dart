// dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/listing_model.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Ensure price value is a number.
    final Object priceValue = listing.price is num
        ? listing.price
        : num.tryParse(listing.price.toString()) ?? 0;
    final formattedPrice = NumberFormat('#,###').format(priceValue);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              child: Image.network(
                listing.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$formattedPrice ETB',
                style:
                theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                listing.location,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.textTheme.bodySmall?.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}