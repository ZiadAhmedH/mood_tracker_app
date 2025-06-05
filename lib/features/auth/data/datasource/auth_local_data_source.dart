
abstract class AuthLocalDataSource {
  Future<void> cacheUserData({
    required String id,
    required String fullName,
    required String email,
    required String createdAt,
  });

  Future<Map<String, String>?> getCachedUserData();
  Future<void> clearUserData();
}
