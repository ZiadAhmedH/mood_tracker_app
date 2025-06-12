import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/features/profile/domain/entities/user.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';

class GetCachedUserUseCase {
  final UserRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<Either<String, User?>> call() async {
    try {
      final user = await repository.getCachedUser();
      if (user == null) {
        return Right(null);  
      } else {
        return Right(user as User?);
      }
    } catch (e) {
      return Left('Failed to get cached user: ${e.toString()}');
    }
  }
}
