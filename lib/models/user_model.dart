// Add to lib/models/user_model.dart
class Users {
  final String id;
  final String? username;
  final String? email;
  // final String? phoneNumber;
  final String? profileImage;
  // other fields...

  Users({
    required this.id,
    this.username,
    this.email,
    // this.phoneNumber,
    this.profileImage,
    // other fields...
  });

  // Add this copyWith method
  Users copyWith({
    String? id,
    String? username,
    String? email,
    // String? phoneNumber,
    String? profileImage,
  }) {
    return Users(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      // phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  // Keep your existing fromMap method
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] ?? '',
      username: map['username'],
      email: map['email'],
      // phoneNumber: map['phone_number'],
      profileImage: map['profile_image'],
    );
  }

  // Add a toMap method if needed
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      // 'phone_number': phoneNumber,
      'profile_image': profileImage,
    };
  }
}