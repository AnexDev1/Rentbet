import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/listing_model.dart';
import '../providers/wishlist_provider.dart';

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

  Future<void> loadGalleryImages(String listingId) async {
    try {
      // Query by the listing id to get gallery_images
      final response = await Supabase.instance.client
          .from('listings')
          .select('gallery_images')
          .eq('id', listingId)
          .single();

      if (response['gallery_images'] != null) {
        galleryImages = List<String>.from(response['gallery_images']);
      } else {
        galleryImages = [];
      }
    } catch (e) {
      print('Error fetching gallery images: $e');
      galleryImages = [];
    } finally {
      isGalleryLoading = false;
      notifyListeners();
    }
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