
class User {
  final String id;
  final String email;
  final String? phone;
  final String? fullName;
  final String? avatarUrl;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.createdAt,
    this.phone,
    this.fullName,
    this.avatarUrl,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, phone: $phone, fullName: $fullName, avatarUrl: $avatarUrl)';
  }
}