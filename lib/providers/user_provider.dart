// file: lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  Users? _user;
  bool _isLoading = false;
  bool _dataLoaded = false;

  Users? get user => _user;
  bool get isLoading => _isLoading;
  bool get isDataLoaded => _dataLoaded;

  void setUser(Users user) {
    _user = user;
    _dataLoaded = true;
    notifyListeners();
  }

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

  void clearUser() {
    _user = null;
    _dataLoaded = false;
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      String? processedImageUrl = profileImage;
      if (profileImage != null && profileImage.isNotEmpty) {
        if (!profileImage.contains('?')) {
          processedImageUrl = '$profileImage?t=${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      final userService = UserService();
      await userService.updateUserProfile(
        username: name,
        profileImage: processedImageUrl,
      );

      _user = _user?.copyWith(
        username: name,
        email: email,
        profileImage: processedImageUrl,
      );

      imageCache.clear();
      imageCache.clearLiveImages();

      await fetchUserData();
    } catch (error) {
      print('Error updating user profile: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}