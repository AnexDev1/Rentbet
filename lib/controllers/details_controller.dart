// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/listing_model.dart';
import '../providers/wishlist_provider.dart';
import '../services/listings_service.dart';

class DetailsController extends ChangeNotifier {
  List<String>? galleryImages;
  bool isGalleryLoading = true;
  bool isBookmarked = false;

  Future<void> loadGalleryImages(String category) async {
    final images = await ListingsService().fetchGalleryImagesByCategory(category);
    galleryImages = images;
    isGalleryLoading = false;
    notifyListeners();
  }

  Future<void> loadBookmarkState(String id) async {
    final prefs = await SharedPreferences.getInstance();
    isBookmarked = prefs.getBool(id) ?? false;
    notifyListeners();
  }

// dart
  Future<void> toggleAndUpdateWishlist(BuildContext context, Map<String, dynamic> property) async {
    // Toggle the bookmark state and update SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    isBookmarked = !isBookmarked;
    prefs.setBool(property['id']!, isBookmarked);
    notifyListeners();

    // Update the wishlist based on the bookmark state.
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    if (isBookmarked) {
      wishlistProvider.addToWishlist(Listing.fromJson(property));
    } else {
      wishlistProvider.removeFromWishlist(property['id']!);
    }
  }
}