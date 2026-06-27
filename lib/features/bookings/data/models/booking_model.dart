import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.userId,
    required super.billboardId,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.totalCredits,
    super.billboardName,
    super.billboardImageUrl,
    super.billboardAddress,
    super.billboardScreenType,
    super.billboardResolution,
    super.assetFileUrl,
    super.assetFileType,
    super.assetFileSizeMb,
    super.assetOriginalFilename,
    super.bookingTypeSlotDuration,
    super.bookingTypeMaxAdsPerSlot,
    super.moderationNotes,
    super.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final billboardData = json['billboards'] as Map<String, dynamic>?;
    final billboardName = billboardData?['name'] as String?;
    final billboardImageUrl = billboardName != null ? _getFallbackImage(billboardName) : null;

    final assetData = json['creative_assets'] as Map<String, dynamic>?;
    final bookingTypeData = json['booking_types'] as Map<String, dynamic>?;

    final resolutionW = billboardData?['resolution_w'];
    final resolutionH = billboardData?['resolution_h'];
    final resString = (resolutionW != null && resolutionH != null)
        ? '${resolutionW}x$resolutionH px'
        : null;

    return BookingModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      billboardId: json['billboard_id'] as String? ?? '',
      startTime: DateTime.parse(json['start_time'] as String).toLocal(),
      endTime: DateTime.parse(json['end_time'] as String).toLocal(),
      status: json['status'] as String? ?? 'pending',
      totalCredits: (json['total_credits'] as num?)?.toDouble() ?? 0.0,
      billboardName: billboardName,
      billboardImageUrl: billboardImageUrl,
      billboardAddress: billboardData?['address'] as String?,
      billboardScreenType: billboardData?['screen_type'] as String?,
      billboardResolution: resString,
      assetFileUrl: assetData?['file_url'] as String?,
      assetFileType: assetData?['file_type'] as String?,
      assetFileSizeMb: (assetData?['file_size_mb'] as num?)?.toDouble(),
      assetOriginalFilename: assetData?['original_filename'] as String?,
      bookingTypeSlotDuration: bookingTypeData?['slot_duration_minutes'] as int?,
      bookingTypeMaxAdsPerSlot: bookingTypeData?['max_ads_per_slot'] as int?,
      moderationNotes: json['moderation_notes'] as String?,
      notes: json['notes'] as String?,
    );
  }

  static String _getFallbackImage(String name) {
    final cleanName = name.toLowerCase();
    if (cleanName.contains('times square') || cleanName.contains('premium')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuCL6aySHykXbJaxrIh4HHnFGYmXwdjrqbxyLibxAL061J1E_9SEmI1tDyNU7dXx-UUvXFlIIdO1aG4K8CIsQsO-Mx2JJ8ihF6d4dOieqEMhQD7Ocou3YdzFM2CINTGvz6JUcbAkPdwOFQW_NGumXCuFvzRag-rYIKSbjVeOj-Obqc3rQGAxYvMuWs8Szx8GnYL714r4XhfyP3Q4UPybjrxVssNaDmdEZAse3P_hGZTMVDDYktff3ZV_2VWi3mTVcQ0ZaUhKL0gSNlY';
    } else if (cleanName.contains('highway') || cleanName.contains('101') || cleanName.contains('road') || cleanName.contains('vía')) {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuBn5L5fe0fOnVf98JJUfGtKM-pVvfXUBL7DCiP5sB2uymO7Omz_7xsHm-YKcumMpmDXDYW7-Be4DFc11HJJoFduzq72ZgvIivdsrwm-O4O5IV8kLvh0UFdOMKq4WPLFSkf7lyJrzXAx9Xjt9bEoBFSpa3o6NXDvx-hJY4vIqCUkWvAgDpXqlzxZUC7KvNXjlPZf4t-Y7xSkcg_Mev7DIJcf_p52P5ShuuhVy_xlXzyiLw9lol1gulLM1ji2R__lc_TOa0A59xn0W9k';
    } else {
      return 'https://lh3.googleusercontent.com/aida-public/AB6AXuCcgK4iVtXghd5xYeUpxpOEB3dUF1_uavllDNqRj0pF_vZxQkXEfshHjKQ3KHlWksM-jwOfHwB2azPtkSjfsUv0o_gjGbA7wpXhIHa9XUc4_L5J1eCOvkdbVlCJUYo-YFpeLtMprwgIiqo9Z56c8SP3ANWm8X4c9vP_onRLpRP0MGSxb-FoH765vJbNbPj_JJ-4EUiaxU2mWgfMz77MP3C5VdY41Ch-kIwwScqE62r7k1q3y-HG-VZAlKklhHW-21wamNOLh0d8ork';
    }
  }
}
