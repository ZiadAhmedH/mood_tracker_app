import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserData({
    required String id,
    required String fullName,
    required String email,
    required String createdAt,
  });

  Future<Map<String, String>?> getCachedUserData();
 
  Future<String?> getUserId();
  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  static const String _keyId = 'USER_ID';
  static const String _keyName = 'USER_NAME';
  static const String _keyEmail = 'USER_EMAIL';
  static const String _keyCreatedAt = 'USER_CREATED_AT';

  @override
  Future<bool> cacheUserData({
    required String id,
    required String fullName,
    required String email,
    required String createdAt,
  }) async {
    print(fullName == 'null' ? 'Full name is null!' : 'Full name is: $fullName');

    final idSuccess = await prefs.setString(_keyId, id);
    final nameSuccess = await prefs.setString(_keyName, fullName);
    final emailSuccess = await prefs.setString(_keyEmail, email);
    final createdAtSuccess = await prefs.setString(_keyCreatedAt, createdAt);

    print('''[CACHE USER DATA]
→ Set USER_ID: $idSuccess
→ Set USER_NAME: $nameSuccess
→ Set USER_EMAIL: $emailSuccess
→ Set USER_CREATED_AT: $createdAtSuccess
→ Stored fullName: "$fullName"
→ Reading back for verification...
→ USER_NAME readback: "${prefs.getString(_keyName)}"
''');

    return idSuccess && nameSuccess && emailSuccess && createdAtSuccess;
  }

  @override
  Future<Map<String, String>?> getCachedUserData() async {
    final id = prefs.getString(_keyId);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);
    final createdAt = prefs.getString(_keyCreatedAt);

    print('''
[GET CACHED USER DATA]
→ USER_ID: $id
→ USER_NAME: "$name"
→ USER_EMAIL: $email
→ USER_CREATED_AT: $createdAt
''');

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
   Future<String?> getUserId() async {
    final cachedUser = await getCachedUserData();
    return cachedUser?['id'];
  }

  @override
  Future<void> clearUserData() async {
    await prefs.remove(_keyId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyCreatedAt);
    print(
      '[CLEAR USER DATA] All user-related keys removed from SharedPreferences.',
    );
  }
}
