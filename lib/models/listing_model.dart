// dart
class Listing {
  final String title;
  final String description;
  final double price;
  final String type;
  final String category;
  final String imageUrl;
  final String location;

  Listing({
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.category,
    required this.imageUrl,
    required this.location,
  });

  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      title: map['title'] as String,
      description: map['description'] as String,
      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price'].toString()) ?? 0.0,
      type: map['type'] as String,
      category: map['category'] as String,
      imageUrl: map['image_url'] as String,
      location: map['location'] as String,
    );
  }
}