import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/features/bookings/data/models/booking_model.dart';

abstract interface class BookingsRemoteDataSource {
  Future<List<BookingModel>> getBillboardBookings(String billboardId);
  Future<double> getUserCredits(String userId);
  Future<String> getActiveBookingTypeId();
  Future<Map<String, dynamic>> calculateBookingPrice({
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<Map<String, dynamic>> createBooking({
    required String userId,
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
    required String assetId,
  });
  Future<Map<String, dynamic>> getCreativeAsset(String assetId);
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<BookingModel> getBookingDetail(String bookingId);
  Future<void> resubmitBooking({required String bookingId, required String assetId, String? notes});
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final SupabaseClient supabaseClient;

  const BookingsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> resubmitBooking({required String bookingId, required String assetId, String? notes}) async {
    try {
      final currentResponse = await supabaseClient
          .from('bookings')
          .select('resubmission_count')
          .eq('id', bookingId)
          .single();
      final resubmissionCount = (currentResponse['resubmission_count'] as num?)?.toInt() ?? 0;

      await supabaseClient
          .from('bookings')
          .update({
            'asset_id': assetId,
            'status': 'resubmitted',
            'resubmission_count': resubmissionCount + 1,
            'notes': notes,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', bookingId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookingModel> getBookingDetail(String bookingId) async {
    try {
      final response = await supabaseClient
          .from('bookings')
          .select('*, billboards(*), booking_types(*), creative_assets(*)')
          .eq('id', bookingId)
          .single();
      return BookingModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final response = await supabaseClient
          .from('bookings')
          .select('*, billboards(name)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final list = response as List<dynamic>;
      return list.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getCreativeAsset(String assetId) async {
    try {
      final response = await supabaseClient
          .from('creative_assets')
          .select('*')
          .eq('id', assetId)
          .single();
      return response;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookingModel>> getBillboardBookings(String billboardId) async {
    try {
      final response = await supabaseClient
          .from('bookings')
          .select('*, billboards(*), creative_assets(*), booking_types(*)')
          .eq('billboard_id', billboardId)
          .inFilter('status', ['approved', 'pending', 'resubmitted']);

      final list = response as List<dynamic>;
      return list.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

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
  Future<String> getActiveBookingTypeId() async {
    try {
      final response = await supabaseClient
          .from('booking_types')
          .select('id')
          .eq('is_active', true)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        throw const ServerException('No hay tipos de reserva configurados en el sistema.');
      }
      return response['id'] as String;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> calculateBookingPrice({
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final response = await supabaseClient.rpc(
        'calculate_booking_price',
        params: {
          'p_billboard_id': billboardId,
          'p_booking_type_id': bookingTypeId,
          'p_start_time': startTime.toIso8601String(),
          'p_end_time': endTime.toIso8601String(),
        },
      );
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> createBooking({
    required String userId,
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
    required String assetId,
  }) async {
    try {
      final response = await supabaseClient.rpc(
        'create_booking',
        params: {
          'p_user_id': userId,
          'p_billboard_id': billboardId,
          'p_booking_type_id': bookingTypeId,
          'p_start_time': startTime.toIso8601String(),
          'p_end_time': endTime.toIso8601String(),
          'p_asset_id': assetId,
        },
      );
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
