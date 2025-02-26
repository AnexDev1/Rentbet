import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;


class AuthService {
  Future<bool> login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.session != null;
  }

  Future<bool> signup(String name, String email, String password) async {
    // Sign up the user with email and password
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    // Check for auth errors

    // If sign up is successful, add the user info to the "users" table
    final insertResponse = await supabase
        .from('users')
        .insert({
      'username': name,
      'email': email,
    });


    // Return true only if either a session or user exists and no error during insert
    return (response.session != null || response.user != null) &&
        insertResponse.error == null;
  }
}