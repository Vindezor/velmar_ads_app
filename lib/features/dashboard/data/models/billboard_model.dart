import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';

class BillboardModel extends Billboard {
  BillboardModel({
    required super.id,
    required super.name,
    required super.address,
    required super.lat,
    required super.lng,
    required super.screenType,
    required super.isActive,
    required super.screenClassLabel,
    required super.pricePerHour,
    required super.imageUrl,
    super.widthM,
    super.heightM,
    super.resolutionW,
    super.resolutionH,
    required super.acceptedFormats,
    super.maxFileSizeMb,
  });

  factory BillboardModel.fromJson(Map<String, dynamic> json) {
    // Parse nested structures from select joins
    final zones = json['zones'] as Map<String, dynamic>?;
    final sizeCategories = json['size_categories'] as Map<String, dynamic>?;
    final screenClasses = json['screen_classes'] as Map<String, dynamic>?;

    final basePrice = (zones?['base_price_per_hour'] as num?)?.toDouble() ?? 0.0;
    final priceMultiplier = (sizeCategories?['price_multiplier'] as num?)?.toDouble() ?? 1.0;
    final pricePerHour = basePrice * priceMultiplier;

    final screenClassLabel = screenClasses?['label'] as String? ?? 'Class A';

    final name = json['name'] as String? ?? '';
    final imageUrl = _getFallbackImage(name);

    return BillboardModel(
      id: json['id'] as String? ?? '',
      name: name,
      address: json['address'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      screenType: json['screen_type'] as String? ?? 'LED',
      isActive: json['is_active'] as bool? ?? true,
      screenClassLabel: screenClassLabel,
      pricePerHour: pricePerHour,
      imageUrl: imageUrl,
      widthM: (json['width_m'] as num?)?.toDouble(),
      heightM: (json['height_m'] as num?)?.toDouble(),
      resolutionW: json['resolution_w'] as int?,
      resolutionH: json['resolution_h'] as int?,
      acceptedFormats: (json['accepted_formats'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['image/jpeg', 'image/png', 'video/mp4'],
      maxFileSizeMb: json['max_file_size_mb'] as int?,
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
