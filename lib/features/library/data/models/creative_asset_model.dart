import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';

class CreativeAssetModel extends CreativeAsset {
  const CreativeAssetModel({
    required super.id,
    required super.userId,
    required super.fileUrl,
    required super.fileType,
    required super.fileSizeMb,
    required super.originalFilename,
    required super.status,
    required super.timesUsed,
    required super.createdAt,
  });

  factory CreativeAssetModel.fromJson(Map<String, dynamic> json) {
    return CreativeAssetModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
      fileType: json['file_type'] as String? ?? 'image',
      fileSizeMb: (json['file_size_mb'] as num?)?.toDouble() ?? 0.0,
      originalFilename: json['original_filename'] as String? ?? 'Sin nombre',
      status: json['status'] as String? ?? 'pending',
      timesUsed: (json['times_used'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String).toLocal()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size_mb': fileSizeMb,
      'original_filename': originalFilename,
      'status': status,
      'times_used': timesUsed,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
