class Listing {
  final String id;
  final String userId;
  final String title;
  final String location;
  final String price;  // Changed to String type
  final String imageUrl;
  final String description;
  final String category;
  final String type;

  Listing({
    this.id = '',
    this.userId = '',

    this.title = '',
    this.location = '',
    this.price = '',  // Default to empty string
    this.imageUrl = '',
    this.description = '',
    this.category = '',
    this.type = '',
  });

  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      // Parse price directly to string with proper formatting
      price: _parsePriceToString(map['price']),
      imageUrl: map['imageUrl']?.toString() ?? map['image_url']?.toString() ?? '',
    );
  }

  // Parse price to formatted string
  static String _parsePriceToString(dynamic value) {
    if (value == null) return '';

    // Already a string
    if (value is String) return value;

    // Handle numeric types with formatting
    if (value is num) {
      if (value == value.roundToDouble()) {
        return value.round().toString();  // "100" instead of "100.0"
      }
      return value.toStringAsFixed(2);    // "100.50" with 2 decimal places
    }

    return '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'location': location,
      'price': price,  // Price is already a string
      'image_url': imageUrl,
      'description': description,
      'type': type,
      'category': category,
    };
  }
}