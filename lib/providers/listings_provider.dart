import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/listings_service.dart';

class ListingsProvider extends ChangeNotifier {
  List<Listing> _listings = [];
  bool _isLoading = true;
  String _currentFilter = 'default';

  List<Listing> get listings => _listings;
  bool get isLoading => _isLoading;
  String get currentFilter => _currentFilter;

  Future<void> fetchListingsByType(String type) async {
    _isLoading = true;
    notifyListeners();

    final results = await ListingsService().fetchListings();
    List<Listing> filtered;
    if (type.toLowerCase() == 'default') {
      filtered = results;
    } else {
      filtered = results
          .where((listing) =>
      listing.type.toLowerCase() == type.toLowerCase())
          .toList();
    }

    _currentFilter = type;
    _listings = filtered;
    _isLoading = false;
    notifyListeners();
  }

  void filterListingsByCategory(String category) {
    if (category.toLowerCase() == 'all') {
      // No additional filtering if "all" is selected.
      notifyListeners();
      return;
    }
    _listings = _listings
        .where((listing) =>
    listing.category.toLowerCase() == category.toLowerCase())
        .toList();
    notifyListeners();
  }
}