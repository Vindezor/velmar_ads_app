import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

abstract interface class BookingsRepository {
  Future<Either<Failure, List<Booking>>> getBillboardBookings(String billboardId);
}
