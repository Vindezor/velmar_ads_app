import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.userId,
    required super.billboardId,
    required super.startTime,
    required super.endTime,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      billboardId: json['billboard_id'] as String? ?? '',
      startTime: DateTime.parse(json['start_time'] as String).toLocal(),
      endTime: DateTime.parse(json['end_time'] as String).toLocal(),
      status: json['status'] as String? ?? 'pending',
    );
  }
}
