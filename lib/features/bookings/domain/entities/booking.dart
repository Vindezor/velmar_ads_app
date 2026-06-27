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
  });
}
