class Booking {
  final String id;
  final String userId;
  final String billboardId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final double totalCredits;
  final String? billboardName;
  final String? billboardImageUrl;
  final String? billboardAddress;
  final String? billboardScreenType;
  final String? billboardResolution;
  final String? assetFileUrl;
  final String? assetFileType;
  final double? assetFileSizeMb;
  final String? assetOriginalFilename;
  final int? bookingTypeSlotDuration;
  final int? bookingTypeMaxAdsPerSlot;
  final String? moderationNotes;
  final String? notes;

  Booking({
    required this.id,
    required this.userId,
    required this.billboardId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalCredits,
    this.billboardName,
    this.billboardImageUrl,
    this.billboardAddress,
    this.billboardScreenType,
    this.billboardResolution,
    this.assetFileUrl,
    this.assetFileType,
    this.assetFileSizeMb,
    this.assetOriginalFilename,
    this.bookingTypeSlotDuration,
    this.bookingTypeMaxAdsPerSlot,
    this.moderationNotes,
    this.notes,
  });
}
