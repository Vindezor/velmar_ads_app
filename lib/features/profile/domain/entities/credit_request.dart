class CreditRequest {
  final String id;
  final String userId;
  final String orderNumber;
  final double creditsRequested;
  final double usdAmount;
  final String? paymentProofUrl;
  final String? paymentNotes;
  final String status;
  final String? adminNotes;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CreditRequest({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.creditsRequested,
    required this.usdAmount,
    this.paymentProofUrl,
    this.paymentNotes,
    required this.status,
    this.adminNotes,
    this.reviewedBy,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
