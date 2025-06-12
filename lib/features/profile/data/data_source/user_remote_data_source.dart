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
    try {
      final response = await client.rpc('get_daily_mood_counts');
      print('📅 Daily Mood Stats Raw Response: $response');

      if (response == null || (response as List).isEmpty) return [];

      return response
          .map((e) => MoodStatModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching daily stats: $e');
      throw Exception('Failed to load daily mood stats: $e');
    }
  }

  @override
  Future<List<MoodStatModel>> getWeeklyMoodStats(String userId) async {
    try {
      final response = await client.rpc('get_weekly_mood_counts');
      print('📈 Weekly Mood Stats Raw Response: $response');

      if (response == null || (response as List).isEmpty) return [];

      return response
          .map((e) => MoodStatModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching weekly stats: $e');
      throw Exception('Failed to load weekly mood stats: $e');
    }
  }

  @override
  Future<List<MoodStatModel>> getMonthlyMoodStats(String userId) async {
    try {
      final response = await client.rpc('get_monthly_mood_counts');
      print('📆 Monthly Mood Stats Raw Response: $response');

      if (response == null || (response as List).isEmpty) return [];

      return response
          .map((e) => MoodStatModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching monthly stats: $e');
      throw Exception('Failed to load monthly mood stats: $e');
    }
  }

  @override
  Future<List<MoodStatModel>> getYearlyMoodStats(String userId) async {
    try {
      final response = await client.rpc('get_yearly_mood_counts');
      print('📅 Yearly Mood Stats Raw Response: $response');

      if (response == null || (response as List).isEmpty) return [];

      return response
          .map((e) => MoodStatModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching yearly stats: $e');
      throw Exception('Failed to load yearly mood stats: $e');
    }
  }

  @override
  Future<void> saveUserMood({
    required String userId,
    required String mood,
    required DateTime createdAt,
  }) async {
    try {
      final payload = {
        'user_id': userId,
        'mood_value': mood, // ✅ Match your SQL table column
        'created_at': createdAt.toIso8601String(),
      };

      print('📝 Saving Mood: $payload');

      final response = await client.from('history_records').insert(payload);

      print('✅ Mood Insert Response: $response');
    } catch (e) {
      print("❌ Error saving mood: $e");
      throw Exception("Error saving mood: $e");
    }
  }
}
