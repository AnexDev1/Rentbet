// lib/services/user_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<Users> getCurrentUser() async {
    try {
      // Get current authenticated user ID from Supabase auth
      final String? userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Query the users table to get username and email
      final response = await _supabase
          .from('users')
          .select('id, username, email')
          .eq('id', userId)
          .single();

      // Map response to your Users model
      return Users.fromMap(response);

    } catch (error) {
      print('Error fetching user data: $error');
      throw Exception('Failed to load user data: $error');
    }
  }

  Future<Users> updateUserProfile({required String username}) async {
    try {
      final String? userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('users')
          .update({'username': username})
          .eq('id', userId)
          .select()
          .single();

      return Users.fromMap(response);
    } catch (error) {
      print('Error updating user profile: $error');
      throw Exception('Failed to update user profile');
    }
  }
}