class Listing {
  final String id;
  final String imageUrl;
  final double? price;
  final String location;
  final String title;
  final String description;
  final String category;
  final String type;
  final bool isBookmarked;

  Listing({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    this.isBookmarked = false,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ??
          json['image_url'] as String? ??
          '',
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price'] is double
          ? json['price'] as double
          : json['price'] is String
          ? double.tryParse(
          (json['price'] as String)
              .replaceAll(RegExp(r'[^\d\.]'), '')) ??
          0.0
          : 0.0,
      location: json['location'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

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
      isBookmarked: map['isBookmarked'] ?? false,
    );
  }

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
      'isBookmarked': isBookmarked,
    };
  }
}