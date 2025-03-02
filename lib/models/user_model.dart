// lib/models/user.dart
class Users {
  final String? username;
  final String? email;
  final String? profileImage;
  final String? id;

  Users({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage

  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      id: data['id'] ?? '',
      username: data['username'] ?? 'User',
      email: data['email'] ?? '',
      profileImage: data['profileImage'] ?? '',
    );
  }
  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json['id'] as String,
    username: json['username'] as String?,
    email: json['email'] as String?,
    profileImage: json['profileImage'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'profileImage': profileImage,
  };
}