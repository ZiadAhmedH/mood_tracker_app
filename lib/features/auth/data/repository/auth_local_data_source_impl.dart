import 'package:moodtracker_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  static const String _keyId = 'USER_ID';
  static const String _keyName = 'USER_NAME';
  static const String _keyEmail = 'USER_EMAIL';
  static const String _keyCreatedAt = 'USER_CREATED_AT';

  @override
  Future<void> cacheUserData({
    required String id,
    required String fullName,
    required String email,
    required String createdAt,
  }) async {
    await prefs.setString(_keyId, id);
    await prefs.setString(_keyName, fullName);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyCreatedAt, createdAt);
  }

  @override
  Future<Map<String, String>?> getCachedUserData() async {
    final id = prefs.getString(_keyId);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);
    final createdAt = prefs.getString(_keyCreatedAt);

    if (id != null && name != null && email != null && createdAt != null) {
      return {
        'id': id,
        'fullName': name,
        'email': email,
        'createdAt': createdAt,
      };
    }
    return null;
  }

  @override
  Future<void> clearUserData() async {
    await prefs.remove(_keyId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyCreatedAt);
  }
}
