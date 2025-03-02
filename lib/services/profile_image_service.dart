// dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImageService {
  final SupabaseClient supabase;
  final String bucketId;

  ProfileImageService({required this.supabase, this.bucketId = 'rentbetStorage'});

  /// Uploads a profile image and returns its public URL,
  /// [userId] is used for generating a unique file path.
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    // Generate a unique file name using the userId and current timestamp.
    final fileExt = imageFile.path.split('.').last;
    final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    // Upload the file.
    final response = await supabase.storage.from(bucketId).upload(filePath, imageFile);


    // Get the file's public URL.
    final publicUrl = supabase.storage.from(bucketId).getPublicUrl(filePath);
    return publicUrl;
  }

  /// Updates the profile image by optionally deleting the old image and uploading the new one.
  /// [oldImagePath] is the storage path of the old image.
  Future<String?> updateProfileImage(String userId, File newImageFile, {String? oldImagePath}) async {
    // If an old image exists, remove it.
    if (oldImagePath != null && oldImagePath.isNotEmpty) {
      final isDeleted = await deleteProfileImage(oldImagePath);
      if (!isDeleted) {
        print('Failed to delete old profile image.');
        return null;
      }
    }
    // Upload the new profile image.
    return await uploadProfileImage(userId, newImageFile);
  }

  /// Deletes the profile image at the given [filePath] in the storage bucket.
  Future<bool> deleteProfileImage(String filePath) async {
    final response = await supabase.storage.from(bucketId).remove([filePath]);

    return true;
  }
}