// lib/services/user_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  // Add to lib/services/user_service.dart
  Future<Users> getUserById(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id, username, email, profile_image')
          .eq('id', userId)
          .single();

      return Users.fromMap(response);
    } catch (error) {
      print('Error fetching user by ID: $error');
      throw Exception('Failed to load user data: $error');
    }
  }
  Future<Users> getCurrentUser() async {
    try {
      // Get current authenticated user ID from Supabase auth
      final String? userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Query the users table to get user data including profile image
      final response = await _supabase
          .from('users')
          .select('id, username, email, profile_image')
          .eq('id', userId)
          .single();

      // Map response to your Users model
      return Users.fromMap(response);

    } catch (error) {
      print('Error fetching user data: $error');
      throw Exception('Failed to load user data: $error');
    }
  }

  Future<Users> updateUserProfile({
    required String username,
    String? profileImage,
    String? email,
    // String? phoneNumber,
  }) async {
    try {
      final String? userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Build update data map
      Map<String, dynamic> updateData = {'username': username};

      // Add optional fields if provided
      if (profileImage != null) {
        updateData['profile_image'] = profileImage;
      }
      if (email != null) {
        updateData['email'] = email;
      }
      // if (phoneNumber != null) {
      //   updateData['phone_number'] = phoneNumber;
      // }

      final response = await _supabase
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return Users.fromMap(response);
    } catch (error) {
      print('Error updating user profile: $error');
      throw Exception('Failed to update user profile: $error');
    }
  }
}