import 'package:velmar_ads/features/profile/domain/entities/movement.dart';

class MovementModel extends Movement {
  const MovementModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.balanceAfter,
    required super.type,
    super.referenceId,
    required super.description,
    required super.createdAt,
  });

  factory MovementModel.fromJson(Map<String, dynamic> json) {
    return MovementModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      type: json['type'] as String,
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
