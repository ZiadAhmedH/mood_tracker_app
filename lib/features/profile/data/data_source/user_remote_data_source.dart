import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mood_stat_model.dart';

abstract class UserRemoteDataSource {
  Future<List<MoodStatModel>> getDailyMoodStats(String userId);
  Future<List<MoodStatModel>> getWeeklyMoodStats(String userId);
  Future<List<MoodStatModel>> getMonthlyMoodStats(String userId);
  Future<List<MoodStatModel>> getYearlyMoodStats(String userId);
  Future<void> saveUserMood({
    required String userId,
    required String mood,
    required DateTime createdAt,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<List<MoodStatModel>> getDailyMoodStats(String userId) async {
    final response =
        await client.rpc('get_daily_mood_counts', params: {'user_id': userId}).select();
    return (response as List).map((e) => MoodStatModel.fromJson(e)).toList();
  }

  @override
  Future<List<MoodStatModel>> getWeeklyMoodStats(String userId) async {
    final response =
        await client.rpc('get_weekly_mood_counts', params: {'user_id': userId}).select();
    return (response as List).map((e) => MoodStatModel.fromJson(e)).toList();
  }

  @override
  Future<List<MoodStatModel>> getMonthlyMoodStats(String userId) async {
    final response =
        await client.rpc('get_monthly_mood_counts', params: {'user_id': userId}).select();
    return (response as List).map((e) => MoodStatModel.fromJson(e)).toList();
  }

  @override
  Future<List<MoodStatModel>> getYearlyMoodStats(String userId) async {
    final response =
        await client.rpc('get_yearly_mood_counts', params: {'user_id': userId}).select();
    return (response as List).map((e) => MoodStatModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveUserMood({
  required String userId,
  required String mood,
  required DateTime createdAt,
}) async {
  final response = await Supabase.instance.client
      .from('user_moods')
      .insert({
        'user_id': userId,
        'mood': mood,
        'created_at': createdAt.toIso8601String(),
      })
      .select(); // returns inserted row if successful

  if (response == null || response.isEmpty) {
    throw Exception("Mood insertion failed.");
  }
}

}
