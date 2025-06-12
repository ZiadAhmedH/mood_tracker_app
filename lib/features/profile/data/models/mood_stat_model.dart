import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';

class MoodStatModel extends MoodStat {
  MoodStatModel({
    required super.mood,
    required super.count,
    required super.createdAt,
  });

  factory MoodStatModel.fromJson(Map<String, dynamic> json) {
  return MoodStatModel(
    mood: json['mood']?.toString() ?? 'unknown',
    count: (json['count'] ?? 0) as int,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'].toString())
        : DateTime.now(), // fallback to now if null
  );
}


  MoodStat toEntity() {
    return MoodStat(
      mood: mood,
      count: count,
      createdAt:createdAt ,
    );
  }
}
