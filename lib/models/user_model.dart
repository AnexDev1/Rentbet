// lib/models/user.dart
class Users {
  final String id;
  final String username;
  final String email;

  Users({
    required this.id,
    required this.username,
    required this.email,
  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      id: data['id'] ?? '',
      username: data['username'] ?? 'User',
      email: data['email'] ?? '',
    );
  }
}