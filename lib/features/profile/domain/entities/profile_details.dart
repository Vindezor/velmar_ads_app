import 'package:velmar_ads/features/profile/domain/entities/movement.dart';

class ProfileDetails {
  final double credits;
  final List<Movement> movements;

  const ProfileDetails({
    required this.credits,
    required this.movements,
  });
}
