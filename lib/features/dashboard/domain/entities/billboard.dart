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
  });
}
