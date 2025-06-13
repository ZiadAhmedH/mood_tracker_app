import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> signUp(String email, String password, String fullName);
  Future<Either<String, User>> loginin(String email, String password);
  Future<Either<String, User>> logOut();
}
