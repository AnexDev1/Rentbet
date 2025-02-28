// lib/providers/wishlist_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/listing_model.dart';
import '../models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  static const _storageKey = 'wishlist_items';
  List<WishlistItem> _wishlist = [];

  List<WishlistItem> get wishlist => _wishlist;

  WishlistProvider() {
    loadWishlist();
  }
  bool isBookmarked(String propertyId) {
    return _wishlist.any((item) => item.id == propertyId);
  }
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList(_storageKey);
    if (storedData != null) {
      _wishlist = storedData
          .map((itemStr) => WishlistItem.fromMap(
          json.decode(itemStr) as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _wishlist
        .map((item) => json.encode(item.toMap()))
        .toList();
    await prefs.setStringList(_storageKey, data);
  }

  bool isInWishlist(String id) {
    return _wishlist.any((item) => item.id == id);
  }

  Future<void> addToWishlist(Listing listing) async {
    if (!isInWishlist(listing.id)) {
      _wishlist.add(WishlistItem.fromListing(listing));
      await _saveWishlist();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String id) async {
    _wishlist.removeWhere((item) => item.id == id);
    await _saveWishlist();
    notifyListeners();
  }

  Future<void> toggleWishlist(Listing listing) async {
    if (isInWishlist(listing.id)) {
      await removeFromWishlist(listing.id);
    } else {
      await addToWishlist(listing);
    }
  }
}