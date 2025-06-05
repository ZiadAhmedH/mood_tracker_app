import 'package:moodtracker_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
abstract class AuthRemoteDataSource {
  Future<User?> signUp(String email, String password ,{required String fullName});
  Future<User?> signIn(String email, String password);
}



class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;
  final AuthLocalDataSource localDataSource;


  AuthRemoteDataSourceImpl(this.client, this.localDataSource);

  @override
  Future<User?> signUp(String email, String password , {required String fullName}) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

  final user = response.user;

    if (user != null) {
      await storeUserData(user: user,email: email, fullName: fullName,
      );
    } 

    return response.user;
  }

  @override
  Future<User?> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );


    return response.user;

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


  Future<User?> getCurrentUser() async {
    final session = client.auth.currentSession;
    print('Current user: ${session?.user}');
    return session?.user;
  }
}
