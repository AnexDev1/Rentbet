import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/user_provider.dart';
final supabase = Supabase.instance.client;

class AuthService {
// dart
  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null && response.user != null) {
        // Fetch the user details from the 'users' table
        final userResponse = await supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();

        // Update the provider with fresh user data
        final user = Users.fromJson(userResponse);
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      // Sign up the user with email and password
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': name}, // Store name in auth metadata too (optional)
      );

      // Check if the signup was successful
      if (response.user != null) {
        // Add the name and email to users table in supabase
        // Include user_id to link with auth user
        await supabase.from('users').insert({
          'id': response.user!.id, // Link to auth user
          'username': name,
          'email': email
        });

        return true;
      } else {
        print('Signup failed: No user returned');
        return false;
      }
    } catch (e) {
      // Handle signup error
      print('Signup error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      throw Exception('Failed to sign out');
    }
  }
}