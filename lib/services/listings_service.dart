// dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/listing_model.dart';

final supabase = Supabase.instance.client;

class ListingsService {
  Future<List<Listing>> fetchListings() async {
    final response = await supabase.from('listings').select();
    final data = response as List;
    return data
        .map((e) => Listing.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}