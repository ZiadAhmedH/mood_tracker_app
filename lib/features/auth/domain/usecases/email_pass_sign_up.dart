import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/features/auth/domain/entities/user.dart';
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';

class SignUpEmailPassUseCase {
  final AuthRepository repository;

  SignUpEmailPassUseCase(this.repository);

  Future<Either<String, User>> call({
    required String email,
    required String password,
    required String fullName,
  }) {
    return repository.signUp(email, password, fullName);
  }
}
