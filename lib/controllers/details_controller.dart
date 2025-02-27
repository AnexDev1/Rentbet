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

  Future<void> toggleBookmarkState(String id) async {
    final prefs = await SharedPreferences.getInstance();
    isBookmarked = !isBookmarked;
    prefs.setBool(id, isBookmarked);
    notifyListeners();
  }

  Future<void> updateWishlist(BuildContext context, Map<String, String> property) async {
    if (isBookmarked) {
      Provider.of<WishlistProvider>(context, listen: false)
          .addToWishlist(Listing.fromMap(property));
    } else {
      Provider.of<WishlistProvider>(context, listen: false)
          .removeFromWishlist(property['id']!);
    }

    // Show snackbar on next frame to ensure a valid ScaffoldMessenger context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final message = isBookmarked ? 'Added to Bookmark' : 'Removed from Bookmark';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }
}