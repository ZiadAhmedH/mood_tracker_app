import 'package:moodtracker_app/features/profile/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.createdAt,
    required super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'],
      createdAt: json['createdAt'],
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
