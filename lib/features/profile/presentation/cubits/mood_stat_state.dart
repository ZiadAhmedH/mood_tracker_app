import 'package:equatable/equatable.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';

abstract class MoodStatsState extends Equatable {
  const MoodStatsState();

  @override
  List<Object?> get props => [];
}

class MoodStatsInitial extends MoodStatsState {}

class MoodStatsLoading extends MoodStatsState {}

class MoodStatsSaving extends MoodStatsState {}

class MoodStatsSaved extends MoodStatsState {
  final String message;

  const MoodStatsSaved(this.message);

  @override
  List<Object?> get props => [message];
}

class MoodStatsLoaded extends MoodStatsState {
  final List<MoodStat> dailyStats;
  final List<MoodStat> weeklyStats;
  final List<MoodStat> monthlyStats;
  final List<MoodStat> yearlyStats;

  const MoodStatsLoaded({
    required this.dailyStats,
    required this.weeklyStats,
    required this.monthlyStats,
    required this.yearlyStats,
  });

  @override
  List<Object?> get props => [dailyStats, weeklyStats, monthlyStats, yearlyStats];
}

class MoodStatsError extends MoodStatsState {
  final String message;
  const MoodStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
