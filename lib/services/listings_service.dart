import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/listing_model.dart';

final SupabaseClient _supabaseClient = Supabase.instance.client;

class ListingsService {
  // Read - fetch all listings
  Future<List<Listing>> fetchListings() async {
    final response = await _supabaseClient.from('listings').select();
    final data = response as List;
    return data
        .map((e) => Listing.fromMap(e as Map<String, dynamic>))
        .toList();
  }
// dart
  Future<List<String>> fetchGalleryImagesByCategory(String category) async {
    final response = await _supabaseClient
        .from('listings')
        .select('image_url')
        .eq('category', category);


    final data = response as List;
    return data.map((item) => item['image_url'] as String).toList();
  }
  // Read - fetch a single listing by id
  Future<Listing?> fetchListingById(int id) async {
    final response = await _supabaseClient
        .from('listings')
        .select()
        .eq('id', id)
        .single();
    return Listing.fromMap(response);
      return null;
  }

  Future<String> createListing(Listing listing) async {
  try {
  final response = await _supabaseClient.from('listings').insert({
  'title': listing.title,
  'location': listing.location,
  'price': listing.price,
  'image_url': listing.imageUrl,
  'description': listing.description,
  'category': listing.category,
  'type': listing.type,
  'created_at': DateTime.now().toIso8601String(),
  'user_id': _supabaseClient.auth.currentUser?.id,
  }).select('id').single();

  return response['id'].toString();
  } catch (e) {
  throw Exception('Failed to create listing: $e');
  }
  }
  }

  // Update - update an existing listing by id
  Future<int> updateListing(int id, Listing updatedListing) async {
    final response = await _supabaseClient
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
    final response = await _supabaseClient
        .from('listings')
        .delete()
        .eq('id', id);
    if (response.error != null) {
      throw Exception('Delete error: \${response.error!.message}');
    }
    // Return the count of deleted rows
    return response.data.length;
  }
