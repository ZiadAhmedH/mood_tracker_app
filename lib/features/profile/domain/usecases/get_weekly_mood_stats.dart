import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';


class GetWeeklyMoodStatsUseCase {
  final UserRepository repository;

  GetWeeklyMoodStatsUseCase(this.repository);

  Future<Either<Failure, List<MoodStat>>> call() async {
    return await repository.getWeeklyMoodStats();
  }
}
