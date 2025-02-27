class Listing {
  final String id; // UUID from Supabase
  final String title;
  final String description;
  final double price;
  final String type;
  final String category;
  final String imageUrl;
  final String location;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.category,
    required this.imageUrl,
    required this.location,
  });

  // Factory method to create a Listing from JSON
  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price'] as double), // Handle int or double
      type: json['type'] as String,
      category: json['category'] as String,
      imageUrl: json['image_url'] as String,
      location: json['location'] as String,
    );
  }
}