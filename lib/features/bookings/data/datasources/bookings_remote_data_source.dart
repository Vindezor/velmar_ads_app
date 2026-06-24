import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/features/bookings/data/models/booking_model.dart';

abstract interface class BookingsRemoteDataSource {
  Future<List<BookingModel>> getBillboardBookings(String billboardId);
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final SupabaseClient supabaseClient;

  const BookingsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<BookingModel>> getBillboardBookings(String billboardId) async {
    try {
      final response = await supabaseClient
          .from('bookings')
          .select('*')
          .eq('billboard_id', billboardId)
          .inFilter('status', ['approved', 'pending', 'resubmitted']);

      final list = response as List<dynamic>;
      return list.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
