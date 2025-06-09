class User {
  final String id;
  final String fullName;
  final String email;
  final String createdAt;
  final String avatarUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.createdAt,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '', // Make sure the key matches the map
      email: json['email'] ?? '',
      createdAt: json['createdAt'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'createdAt': createdAt,
      'avatarUrl': avatarUrl,
    };
  }
}
