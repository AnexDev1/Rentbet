import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/wishlist_provider.dart';
import '../services/listings_service.dart';

class DetailsController extends ChangeNotifier {
  final WishlistProvider _wishlistProvider;
  List<String>? galleryImages;
  bool isGalleryLoading = true;
  bool isBookmarked = false;

  DetailsController(this._wishlistProvider);

  // Alternative constructor if you need to create without provider
  factory DetailsController.create(BuildContext context) {
    return DetailsController(
        Provider.of<WishlistProvider>(context, listen: false)
    );
  }

  Future<void> loadGalleryImages(String category) async {
    isGalleryLoading = true;
    notifyListeners();

    final images = await ListingsService().fetchGalleryImagesByCategory(category);
    galleryImages = images;
    isGalleryLoading = false;
    notifyListeners();
  }

  // Update bookmark state from WishlistProvider
  void loadBookmarkState(String propertyId) {
    isBookmarked = _wishlistProvider.isBookmarked(propertyId);
    notifyListeners();
  }

  // Toggle bookmark using only WishlistProvider
  Future<void> toggleBookmark(Listing listing) async {
    if (_wishlistProvider.isBookmarked(listing.id)) {
      await _wishlistProvider.removeFromWishlist(listing.id);
      isBookmarked = false;
    } else {
      await _wishlistProvider.addToWishlist(listing);
      isBookmarked = true;
    }
    notifyListeners();
  }
}