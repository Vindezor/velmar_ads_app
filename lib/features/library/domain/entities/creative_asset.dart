class CreativeAsset {
  final String id;
  final String userId;
  final String fileUrl;
  final String fileType;
  final double fileSizeMb;
  final String originalFilename;
  final String status;
  final int timesUsed;
  final DateTime createdAt;

  const CreativeAsset({
    required this.id,
    required this.userId,
    required this.fileUrl,
    required this.fileType,
    required this.fileSizeMb,
    required this.originalFilename,
    required this.status,
    required this.timesUsed,
    required this.createdAt,
  });
}
