import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/features/library/data/models/creative_asset_model.dart';

abstract interface class LibraryRemoteDataSource {
  Future<String> uploadAdContent({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  });

  Future<void> deleteAdContent(String path);

  Future<String> createCreativeAsset({
    required String userId,
    required String fileUrl,
    required String fileName,
  });

  Future<void> deleteCreativeAsset(String assetId);

  Future<List<CreativeAssetModel>> getUserAssets(String userId);
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
  Future<void> deleteAdContent(String path) async {
    try {
      await supabaseClient.storage.from('ad-content').remove([path]);
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

  @override
  Future<void> deleteCreativeAsset(String assetId) async {
    try {
      await supabaseClient.from('creative_assets').delete().eq('id', assetId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CreativeAssetModel>> getUserAssets(String userId) async {
    try {
      final response = await supabaseClient
          .from('creative_assets')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      final list = response as List<dynamic>;
      return list.map((json) => CreativeAssetModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
