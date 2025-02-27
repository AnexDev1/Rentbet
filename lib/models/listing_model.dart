// dart
class Listing {
  final String id;
  final String imageUrl;
  final double price;
  final String location;
  final String title;
  final String description;
  final String category;
  final String type;

  Listing({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
  });

  // Convert a Listing from a JSON
  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      imageUrl: json['image_url'] as String,
      price: (json['price'] is int ? (json['price'] as int).toDouble() : json['price'] as double),
      location: json['location'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
    );
  }

  // Convert a Listing from a Map
  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      id: map['id'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      location: map['location'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      type: map['type'],
    );
  }

  // Convert a Listing to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'price': price,
      'location': location,
      'title': title,
      'description': description,
      'category': category,
      'type': type,
    };
  }
}