import 'listing_model.dart';

class WishlistItem {
  final String id;
  final String title;
  final String location;
  final String price;
  final String imageUrl;
  final String description;
  final String category;
  final String type;

  WishlistItem({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.type,
  });

  // Create WishlistItem from a Listing
  factory WishlistItem.fromListing(Listing listing) {
    return WishlistItem(
      id: listing.id,
      title: listing.title,
      location: listing.location,
      price: listing.price,
      imageUrl: listing.imageUrl,
      description: listing.description,
      category: listing.category,
      type: listing.type,
    );
  }

  // Create from a Map (for JSON deserialization)
  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      price: map['price'] ?? '',
      imageUrl: map['image_url'] ?? map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      type: map['type'] ?? '',
    );
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'category': category,
      'type': type,
    };
  }
}