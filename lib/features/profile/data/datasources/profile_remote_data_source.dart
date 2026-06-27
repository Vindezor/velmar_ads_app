import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/features/profile/data/models/movement_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<double> getUserCredits(String userId);
  Future<List<MovementModel>> getMovementHistory(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<double> getUserCredits(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('credits')
          .eq('id', userId)
          .single();
      return (response['credits'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MovementModel>> getMovementHistory(String userId) async {
    try {
      final response = await supabaseClient
          .from('credit_ledger')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => MovementModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
