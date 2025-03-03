// lib/providers/user_provider.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

      final userData = await UserService().getCurrentUser();
      _user = userData;
      _dataLoaded = true;

    } catch (error) {
      print('Error fetching user data: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    // String? phone,
    String? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Add cache-busting parameter to prevent caching issues
      String? processedImageUrl = profileImage;
      if (profileImage != null && profileImage.isNotEmpty) {
        if (!profileImage.contains('?')) {
          processedImageUrl = '$profileImage?t=${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      // Update user profile in database
      final userService = UserService();
      await userService.updateUserProfile(
        username: name,
        profileImage: processedImageUrl, // Pass the processed image URL
      );

      // Update local user object immediately instead of refetching
      _user = _user?.copyWith(
        username: name,
        email: email,
        // phoneNumber: phone,
        profileImage: processedImageUrl,
      );

      // Clear image cache to force reload
      imageCache.clear();
      imageCache.clearLiveImages();

      // Then fetch fresh data to ensure UI is updated
      await fetchUserData();

    } catch (error) {
      print('Error updating user profile: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}