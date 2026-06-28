import 'package:velmar_ads/core/common/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final metadata = json['user_metadata'] as Map<String, dynamic>?;
    final parsedName = json['name'] ?? json['full_name'] ?? metadata?['full_name'] ?? '';
    final parsedPhone = json['phone'] ?? json['phone_number'] ?? metadata?['phone'] ?? '';
    
    return UserModel(
      id: json['id'] ?? '',
      name: parsedName,
      email: json['email'] ?? '',
      phone: parsedPhone,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}
