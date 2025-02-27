// dart
import 'package:flutter/material.dart';
import '../models/listing_model.dart';

class WishlistProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _wishlist = [];

  List<Map<String, dynamic>> get wishlist => _wishlist;
  void addToWishlist(Listing listing) {
    _wishlist.add(listing.toMap());
    notifyListeners();
  }

  void removeFromWishlist(String id) {
    _wishlist.removeWhere((listing) => listing['id'] == id);
    notifyListeners();
  }

  bool isInWishlist(String id) {
    return _wishlist.any((listing) => listing['id'] == id);
  }
}