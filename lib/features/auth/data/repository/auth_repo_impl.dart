import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:moodtracker_app/features/auth/domain/entities/user.dart' as domain;
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemote;

  AuthRepositoryImpl({
    required this.authRemote,
  });

  @override
  Future<Either<String, domain.User>> signUp(String email, String password, String fullName) async {
    try {
      final supabaseUser = await authRemote.signUp(email, password, fullName: fullName);

      if (supabaseUser == null) {
        return Left("Signup failed: No user returned");
      }

      final user = domain.User(
        id: supabaseUser.id,
        email: email,
        fullName: fullName,
        phone: supabaseUser.phone ?? '',
        avatarUrl: supabaseUser.userMetadata?['avatar_url'] ?? '',
        createdAt: DateTime.now().toUtc().toIso8601String(),
      );

      return Right(user);
    } on AuthException catch (e) {
      return Left('Signup error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, domain.User>> loginin(String email, String password) async {
    try {
      final supabaseUser = await authRemote.signIn(email, password);

      if (supabaseUser == null) {
        return Left("Login failed: No user returned");
      }

      final user = domain.User(
        id: supabaseUser.id,
        email: email,
        fullName: supabaseUser.userMetadata?['full_name'] ?? '',
        phone: supabaseUser.phone ,
        avatarUrl: supabaseUser.userMetadata?['avatar_url'] ?? '',
        createdAt: DateTime.now().toUtc().toIso8601String(),
      );

      return Right(user);
    } on AuthException catch (e) {
      return Left('Login error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
