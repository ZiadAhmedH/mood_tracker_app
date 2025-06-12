import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_daily_mood_stats.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_monthly_mood_stats.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_weekly_mood_stats.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_yearly_mood_stats.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/save_use_mood.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_state.dart';

class MoodStatsCubit extends Cubit<MoodStatsState> {
  final GetDailyMoodStatsUseCase getDailyMoodStats;
  final GetWeeklyMoodStatsUseCase getWeeklyMoodStats;
  final GetMonthlyMoodStatsUseCase getMonthlyMoodStats;
  final GetYearlyMoodStatsUseCase getYearlyMoodStats;
  final SaveUserMoodUseCase saveUserMood;

  MoodStatsCubit({
    required this.getDailyMoodStats,
    required this.getWeeklyMoodStats,
    required this.getMonthlyMoodStats,
    required this.getYearlyMoodStats,
    required this.saveUserMood,
  }) : super(MoodStatsInitial());

 Future<void> loadStats() async {
  emit(MoodStatsLoading());

  final dailyResult = await getDailyMoodStats();
  if (dailyResult.isLeft()) {
    emit(MoodStatsError("$dailyResult"));
    return;
  }
  final dailyStats = dailyResult.getOrElse(() => []);

  final weeklyResult = await getWeeklyMoodStats();
  if (weeklyResult.isLeft()) {
    emit(MoodStatsError("$weeklyResult"));
    return;
  }
  final weeklyStats = weeklyResult.getOrElse(() => []);

  final monthlyResult = await getMonthlyMoodStats();
  if (monthlyResult.isLeft()) {
    emit(MoodStatsError("$monthlyResult"));
    return;
  }
  final monthlyStats = monthlyResult.getOrElse(() => []);

  final yearlyResult = await getYearlyMoodStats();
  if (yearlyResult.isLeft()) {
    emit(MoodStatsError("$yearlyResult"));
    return;
  }
  final yearlyStats = yearlyResult.getOrElse(() => []);

  emit(MoodStatsLoaded(
    dailyStats: dailyStats,
    weeklyStats: weeklyStats,
    monthlyStats: monthlyStats,
    yearlyStats: yearlyStats,
  ));
}

  Future<void> saveMood({
    required String mood,
    required DateTime createdAt,
  }) async {
    emit(MoodStatsSaving());

    final result = await saveUserMood(mood: mood, createdAt: createdAt);

    result.fold(
      (failure) => emit(MoodStatsError(failure.toString())),
      (_) => emit(MoodStatsSaved("Mood saved successfully!")),
    );
  }
}
