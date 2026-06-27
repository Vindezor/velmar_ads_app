import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';

class CreditRequestModel extends CreditRequest {
  const CreditRequestModel({
    required super.id,
    required super.userId,
    required super.orderNumber,
    required super.creditsRequested,
    required super.usdAmount,
    super.paymentProofUrl,
    super.paymentNotes,
    required super.status,
    super.adminNotes,
    super.reviewedBy,
    super.reviewedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CreditRequestModel.fromJson(Map<String, dynamic> json) {
    return CreditRequestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderNumber: json['order_number'] as String,
      creditsRequested: (json['credits_requested'] as num).toDouble(),
      usdAmount: (json['usd_amount'] as num).toDouble(),
      paymentProofUrl: json['payment_proof_url'] as String?,
      paymentNotes: json['payment_notes'] as String?,
      status: json['status'] as String? ?? 'pending',
      adminNotes: json['admin_notes'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null 
          ? DateTime.parse(json['reviewed_at'] as String) 
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'order_number': orderNumber,
      'credits_requested': creditsRequested,
      'usd_amount': usdAmount,
      if (paymentProofUrl != null) 'payment_proof_url': paymentProofUrl,
      if (paymentNotes != null) 'payment_notes': paymentNotes,
      'status': status,
      if (adminNotes != null) 'admin_notes': adminNotes,
      if (reviewedBy != null) 'reviewed_by': reviewedBy,
      if (reviewedAt != null) 'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }
}
