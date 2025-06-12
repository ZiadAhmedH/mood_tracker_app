import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';

import '../entities/mod_stat.dart';

class SaveUserMoodUseCase {
  final UserRepository repository;

  SaveUserMoodUseCase(this.repository);

  Future<Either<Failure, MoodStat>> call({
    required String mood,
    required DateTime createdAt,
  }) {
    return repository.saveUserMood(mood: mood, createdAt: createdAt);
  }
}
