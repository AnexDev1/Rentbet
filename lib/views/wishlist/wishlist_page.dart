// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/listing_model.dart';
import '../../providers/wishlist_provider.dart';
import '../details/details_page.dart';
import '../listings/widgets/listing_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: wishlist.isEmpty
          ? const Center(child: Text('No properties in wishlist.'))
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final listingMap = wishlist[index];
          print(listingMap);
          return ListingCard(
            listing: Listing.fromMap(listingMap),
            onTap: () {

            },
          );
        },
      ),
    );
  }
}