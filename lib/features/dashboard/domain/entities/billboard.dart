class Billboard {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String screenType;
  final bool isActive;
  final String screenClassLabel;
  final double pricePerHour;
  final String imageUrl;
  final double? widthM;
  final double? heightM;
  final int? resolutionW;
  final int? resolutionH;
  final List<String> acceptedFormats;

  Billboard({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.screenType,
    required this.isActive,
    required this.screenClassLabel,
    required this.pricePerHour,
    required this.imageUrl,
    this.widthM,
    this.heightM,
    this.resolutionW,
    this.resolutionH,
    required this.acceptedFormats,
  });
}
