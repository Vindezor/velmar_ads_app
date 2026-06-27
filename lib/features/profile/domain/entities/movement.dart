class Movement {
  final String id;
  final String userId;
  final double amount;
  final double balanceAfter;
  final String type;
  final String? referenceId;
  final String description;
  final DateTime createdAt;

  const Movement({
    required this.id,
    required this.userId,
    required this.amount,
    required this.balanceAfter,
    required this.type,
    this.referenceId,
    required this.description,
    required this.createdAt,
  });
}
