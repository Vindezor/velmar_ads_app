import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/features/profile/data/models/movement_model.dart';
import 'package:velmar_ads/features/profile/data/models/credit_request_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<double> getUserCredits(String userId);
  Future<List<MovementModel>> getMovementHistory(String userId);
  Future<String> uploadPaymentProof({
    required Uint8List fileBytes,
    required String path,
  });
  Future<void> deletePaymentProof(String path);
  Future<void> createCreditRequest(CreditRequestModel request);
  Future<List<CreditRequestModel>> getCreditRequests(String userId);
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

  @override
  Future<String> uploadPaymentProof({
    required Uint8List fileBytes,
    required String path,
  }) async {
    try {
      await supabaseClient.storage.from('payment-proofs').uploadBinary(path, fileBytes);
      return supabaseClient.storage.from('payment-proofs').getPublicUrl(path);
    } catch (e) {
      dev.log('Error al subir comprobante a Supabase (payment-proofs): $e');
      throw ServerException('Error al subir comprobante a Supabase (payment-proofs): $e');
    }
  }

  @override
  Future<void> deletePaymentProof(String path) async {
    try {
      await supabaseClient.storage.from('payment-proofs').remove([path]);
    } catch (e) {
      throw ServerException('Error al eliminar comprobante de Supabase (payment-proofs): $e');
    }
  }

  @override
  Future<void> createCreditRequest(CreditRequestModel request) async {
    try {
      await supabaseClient.from('credit_requests').insert(request.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CreditRequestModel>> getCreditRequests(String userId) async {
    try {
      final response = await supabaseClient
          .from('credit_requests')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => CreditRequestModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
