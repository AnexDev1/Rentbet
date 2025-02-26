import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;

class AuthService {
  Future<bool> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session != null;
    } catch (e) {
      // Handle login error
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
      );



      // If sign up is successful, add the user info to the "users" table
      // final insertResponse = await supabase
      //     .from('users')
      //     .insert({
      //   'username': name,
      //   'email': email,
      // });

      // Return true only if either a session or user exists and no error during insert
      return (response.session != null || response.user != null) ;// insertResponse.error == null;

    } catch (e) {
      // Handle signup error
      print('Signup error: $e');
      return false;
    }
  }
}