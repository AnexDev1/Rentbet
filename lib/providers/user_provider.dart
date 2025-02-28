// lib/providers/user_provider.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rentbet/services/user_service.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  Users? _user;
  bool _isLoading = false;

  Users? get user => _user;
  bool get isLoading => _isLoading;
  bool _dataLoaded = false;
  bool get isDataLoaded => _dataLoaded;
  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Replace with your actual user service implementation
      final userData = await UserService().getCurrentUser();
      _user = userData;

    } catch (error) {
      print('Error fetching user data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    _dataLoaded =true;
  }
  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? phone,
    File? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Upload image if provided
      String? photoURL;
      if (profileImage != null) {
        photoURL = await _uploadProfileImage(profileImage);
      }

      // 2. Update user profile in database
      final userService = UserService();
      await userService.updateUserProfile(
        username: name,
      );

      // 3. Fetch fresh data to update the UI with new values
      await fetchUserData();
    } catch (error) {
      print('Error updating user profile: $error');
      // Consider showing an error message to the user
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<String> _uploadProfileImage(File imageFile) async {
    // Implement file upload to storage
    // This would connect to your storage service (Firebase, Supabase, etc.)
    // Return the URL of the uploaded image

    // Placeholder implementation:
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    // Upload to storage and get URL
    // ...
    return 'https://example.com/$fileName'; // Replace with actual URL
  }
}