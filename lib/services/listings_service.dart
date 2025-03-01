import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/listing_model.dart';

final supabase = Supabase.instance.client;

class ListingsService {
  // Read - fetch all listings
  Future<List<Listing>> fetchListings() async {
    final response = await supabase.from('listings').select();
    final data = response as List;
    return data
        .map((e) => Listing.fromMap(e as Map<String, dynamic>))
        .toList();
  }
// dart
  Future<List<String>> fetchGalleryImagesByCategory(String category) async {
    final response = await supabase
        .from('listings')
        .select('image_url')
        .eq('category', category);


    final data = response as List;
    return data.map((item) => item['image_url'] as String).toList();
  }
  // Read - fetch a single listing by id
  Future<Listing?> fetchListingById(int id) async {
    final response = await supabase
        .from('listings')
        .select()
        .eq('id', id)
        .single();
    return Listing.fromMap(response);
      return null;
  }

  // Create - insert a new listing
  Future<int> createListing(Listing listing) async {
    final user = supabase.auth.currentUser?.id;
    if(user == null) {
      throw Exception('User not authenticated');
    }

    final payload = listing.toMap();
    payload['user_id'] = user;
    final response = await supabase
        .from('listings')
        .insert(payload);
    if (response.error != null) {
      throw Exception('Insert error: \${response.error!.message}');
    }
    // Return the id of the newly created listing if available
    final data = response.data as List;
    return data.isNotEmpty ? data.first['id'] as int : 0;
  }

  // Update - update an existing listing by id
  Future<int> updateListing(int id, Listing updatedListing) async {
    final response = await supabase
        .from('listings')
        .update(updatedListing.toMap())
        .eq('id', id);
    if (response.error != null) {
      throw Exception('Update error: \${response.error!.message}');
    }
    // Return the count of updated rows
    return response.data.length;
  }

  // Delete - remove a listing by id
  Future<int> deleteListing(int id) async {
    final response = await supabase
        .from('listings')
        .delete()
        .eq('id', id);
    if (response.error != null) {
      throw Exception('Delete error: \${response.error!.message}');
    }
    // Return the count of deleted rows
    return response.data.length;
  }
}