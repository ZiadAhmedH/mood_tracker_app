import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/features/auth/domain/entities/user.dart';
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);


  Future<Either<String, User>> call({required String email, required String password}) async {
    return await repository.loginin(
      email,
      password,
    );
  }
}


