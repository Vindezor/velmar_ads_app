import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

abstract interface class BookingsRepository {
  Future<Either<Failure, List<Booking>>> getBillboardBookings(String billboardId);
  Future<Either<Failure, double>> getUserCredits(String userId);
  Future<Either<Failure, String>> getActiveBookingTypeId();
  Future<Either<Failure, Map<String, dynamic>>> calculateBookingPrice({
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<Either<Failure, Map<String, dynamic>>> createBooking({
    required String userId,
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
    required String assetId,
  });
  Future<Either<Failure, Map<String, dynamic>>> getCreativeAsset(String assetId);
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId);
  Future<Either<Failure, Booking>> getBookingDetail(String bookingId);
}
