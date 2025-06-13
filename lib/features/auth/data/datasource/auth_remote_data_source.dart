import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<User?> signUp(
    String email,
    String password, {
    required String fullName,
  });
  Future<User?> signIn(String email, String password);
  // logout
  Future<User?> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl(this.client, this.localDataSource);

  @override
  Future<User?> signUp(
    String email,
    String password, {
    required String fullName,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'username': fullName},
    );

    final user = response.user;

    if (user != null) {
      await storeUserData(user: user, email: email, fullName: fullName);
    }

    return user;
  }
@override
Future<User?> signIn(String email, String password) async {
  final response = await client.auth.signInWithPassword(
    email: email,
    password: password,
  );

  final user = response.user!;
 String? username = user.userMetadata?['username'];

if (username == null || username.isEmpty) {
  username = await _getUsernameFromDatabase(user.id);
}

if (username.isEmpty) {
  throw Exception('Failed to fetch user full name from Supabase.');
}

// NOW this is safe
await localDataSource.cacheUserData(
  id: user.id,
  fullName: username,
  email: email,
  createdAt: DateTime.now().toUtc().toIso8601String(),
);


  print('User signed in: $user');

  return user;
}



  Future<void> storeUserData({
    required User user,
    required String email,
    required String fullName,
  }) async {
    await client.from('users').insert({
      'id': user.id,
      'email': email,
      'full_name': fullName,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
    await localDataSource.cacheUserData(
      id: user.id,
      fullName: fullName,
      email: email,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

 Future<String> _getUsernameFromDatabase(String userId) async {
  final response = await client
      .from('users')
      .select('full_name')
      .eq('id', userId)
      .maybeSingle();

  print('[DB FETCH] userId: $userId, result: $response');
  
  print('[DB FETCH] Full name: ${response!['full_name']}');

  return response['full_name'];
}


  Future<User?> getCurrentUser() async {
    final session = client.auth.currentSession;
    print('Current user: ${session?.user}');
    return session?.user;
  }
  
  @override
  Future<User?> logOut() async {
    final user = client.auth.currentUser;
    await client.auth.signOut();
    await localDataSource.clearUserData();
    return user;
  }
}
