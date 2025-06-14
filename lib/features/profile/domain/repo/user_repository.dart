import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getCachedUser();
   Future<Either<Failure, MoodStat>> saveUserMood({required String mood,required DateTime createdAt, });
  Future<Either<Failure, List<MoodStat>>> getWeeklyMoodStats();
  Future<Either<Failure, List<MoodStat>>> getMonthlyMoodStats();
  Future<Either<Failure, List<MoodStat>>> getYearlyMoodStats();
}
