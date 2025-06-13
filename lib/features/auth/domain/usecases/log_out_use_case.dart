import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';
import 'package:moodtracker_app/features/profile/domain/entities/user.dart';


class LogOutUseCase {
  final AuthRepository authRepository;

  LogOutUseCase(this.authRepository);

  Future<Either<Failure, User>> call() async {
    final logoutResult = await authRepository.logOut();
      return  logoutResult.fold(
        (failure) => Left("Failed to log out: $failure" as Failure),
        (user) => Right(user as User),
      );
  }
}