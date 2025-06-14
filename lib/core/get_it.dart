import 'package:get_it/get_it.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/log_out_use_case.dart';
import 'package:moodtracker_app/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_weekly_mood_stats.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_yearly_mood_stats.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/save_use_mood.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ Audio Service (Quran Feature)
import 'package:moodtracker_app/features/suggestion_treatment/quran/data/service/audio_service.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/presentation/controller/surah_playback_controller.dart';

// ✅ Auth Feature
import 'package:moodtracker_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/email_pass_sign_up.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';

// ✅ Profile Feature
import 'package:moodtracker_app/features/profile/data/repo/user_repository_impl.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_cahed_User.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_cubit.dart';

// ✅ Emotion Detection Feature
import 'package:moodtracker_app/features/emotion_detection/data/data_source/emotion_question_remote_data_source.dart';
import 'package:moodtracker_app/features/emotion_detection/data/repo/emotion_question_repository_impl.dart';
import 'package:moodtracker_app/features/emotion_detection/domain/repo/emotion_question_repository.dart';
import 'package:moodtracker_app/features/emotion_detection/domain/usecases/fetch_emotion_questions.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/cubits/emotion_question_cubit.dart';

import '../features/profile/domain/usecases/get_monthly_mood_stats.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------------------------------
  // ✅ Core Services
  // -------------------------------
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);

  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);

  // -------------------------------
  // ✅ Audio Playback (Quran Feature)
  // -------------------------------
  sl.registerLazySingleton<AudioServiceImpl>(() => AudioServiceImpl());
  sl.registerLazySingleton<SurahPlaybackController>(() => SurahPlaybackController());

  // -------------------------------
  // ✅ Auth Feature
  // -------------------------------
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemote: sl()),
  );

  sl.registerLazySingleton(() => SignUpEmailPassUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));

  // -------------------------------
  // ✅ Profile Feature
  // -------------------------------
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl() , sl() , sl()),
  );

  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));

  // -------------------------------
  // ✅ Emotion Detection Feature
  // -------------------------------
  sl.registerLazySingleton<EmotionQuestionRemoteDataSource>(
    () => EmotionQuestionRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<EmotionQuestionRepository>(
    () => EmotionQuestionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => FetchEmotionQuestions(sl()));
  sl.registerFactory(() => EmotionQuestionCubit(sl()));


  // -------------------------------
  // statistucs mood
  // -------------------------------

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl()));
   

  // You can register more dependencies here as needed

sl.registerLazySingleton(() => GetWeeklyMoodStatsUseCase(sl()));
sl.registerLazySingleton(() => GetMonthlyMoodStatsUseCase(sl()));
sl.registerLazySingleton(() => GetYearlyMoodStatsUseCase(sl()));
sl.registerLazySingleton(() => SaveUserMoodUseCase(sl()));


   

sl.registerFactory(() => MoodStatsCubit(
  getWeeklyMoodStats: sl(),
  getMonthlyMoodStats: sl(),
  getYearlyMoodStats: sl(),
  saveUserMood: sl(),
));

}
