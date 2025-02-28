// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:rentbet/services/user_service.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  Users? _user;
  bool _isLoading = false;

  Users? get user => _user;
  bool get isLoading => _isLoading;

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
  }
}