import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';


class MoodStatModel extends MoodStat {
  MoodStatModel({required super.mood, required super.count, required super.createdAt});

  factory MoodStatModel.fromJson(Map<String, dynamic> json) {
    return MoodStatModel(
      mood: json['mood'] as String,
      count: json['count'] as int, createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
