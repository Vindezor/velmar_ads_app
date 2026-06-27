import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';

abstract interface class LibraryRemoteDataSource {
  Future<String> uploadAdContent({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  });

  Future<String> createCreativeAsset({
    required String userId,
    required String fileUrl,
    required String fileName,
  });
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final SupabaseClient supabaseClient;

  LibraryRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> uploadAdContent({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  }) async {
    try {
      final path = '$userId/$fileName';
      await supabaseClient.storage.from('ad-content').uploadBinary(
            path,
            Uint8List.fromList(fileBytes),
            fileOptions: const FileOptions(contentType: 'image/png'),
          );
      return supabaseClient.storage.from('ad-content').getPublicUrl(path);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> createCreativeAsset({
    required String userId,
    required String fileUrl,
    required String fileName,
  }) async {
    try {
      final response = await supabaseClient.from('creative_assets').insert({
        'user_id': userId,
        'file_url': fileUrl,
        'file_type': 'image',
        'file_size_mb': 0.0001,
        'original_filename': fileName,
        'status': 'pending',
      }).select('id').single();
      return response['id'] as String;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
