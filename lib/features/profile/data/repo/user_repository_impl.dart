import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:moodtracker_app/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:moodtracker_app/features/profile/data/models/mood_stat_model.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';
import 'package:moodtracker_app/features/profile/domain/entities/user.dart' as profile_user;
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final SupabaseClient client;

  UserRepositoryImpl(this.localDataSource, this.remoteDataSource, this.client);

  @override
  Future<Either<Failure, profile_user.User>> getCachedUser() async {
    try {
      final cached = await localDataSource.getCachedUserData();
      if (cached == null) {
        return Left(CacheFailure('No cached user found'));
      }

      final user = profile_user.User.fromJson({
        'id': cached['id'],
        'fullName': cached['fullName'],
        'email': cached['email'],
        'createdAt': cached['createdAt'],
        'avatarUrl': cached['avatarUrl'] ?? '',
      });

      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<MoodStat>>> _getMoodStats(
      Future<List<MoodStatModel>> Function(String userId) fetcher) async {
    try {
      final cachedUserId = await localDataSource.getUserId();
      if (cachedUserId == null) {
        return Left(CacheFailure('No user ID found in cache'));
      }

      final modelList = await fetcher(cachedUserId);
      final entityList = modelList.map((e) => e.toEntity()).toList();

      return Right(entityList);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MoodStat>>> getDailyMoodStats() {
    return _getMoodStats(remoteDataSource.getDailyMoodStats);
  }

  @override
  Future<Either<Failure, List<MoodStat>>> getWeeklyMoodStats() {
    return _getMoodStats(remoteDataSource.getWeeklyMoodStats);
  }

  @override
  Future<Either<Failure, List<MoodStat>>> getMonthlyMoodStats() {
    return _getMoodStats(remoteDataSource.getMonthlyMoodStats);
  }

  @override
  Future<Either<Failure, List<MoodStat>>> getYearlyMoodStats() {
    return _getMoodStats(remoteDataSource.getYearlyMoodStats);
  }

  @override
  Future<Either<Failure, MoodStat>> saveUserMood({
    required String mood,
    required DateTime createdAt,
  }) async {
    try {
      final userId = await localDataSource.getUserId();

      if (userId == null) {
        return Left(ServerFailure("User not authenticated."));
      }

      final response = await client
          .from('history_records')
          .insert({
            'user_id': userId,
            'mood_value': mood,
            'created_at': createdAt.toIso8601String(),
          })
          .select()
          .single();

      return Right(
        MoodStat(
          mood: response['mood_value'],
          count: 1,
          createdAt: DateTime.parse(response['created_at']),
        ),
      );
    } catch (e) {
      return Left(ServerFailure("Failed to save mood: ${e.toString()}"));
    }
  }
}
