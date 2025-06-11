import 'package:get_it/get_it.dart';
import 'package:moodtracker_app/features/image_emotion_detection/domain/usecases/fetch_emotion_questions.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/cubits/emotion_question_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth Feature
import 'package:moodtracker_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/email_pass_sign_up.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';

// Profile Feature
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';
import 'package:moodtracker_app/features/profile/data/repo/user_repository_impl.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_cahed_User.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_cubit.dart';

// Emotion Assessment Feature
import 'package:moodtracker_app/features/image_emotion_detection/data/data_source/emotion_question_remote_data_source.dart';
import 'package:moodtracker_app/features/image_emotion_detection/data/repo/emotion_question_repository_impl.dart';
import 'package:moodtracker_app/features/image_emotion_detection/domain/repo/emotion_question_repository.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // ✅ Shared Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);

  // ✅ Supabase Client
  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);

  // -------------------------------
  // ✅ Auth Feature Setup
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

  sl.registerFactory(() => AuthCubit(sl(), sl()));

  // -------------------------------
  // ✅ Profile Feature Setup
  // -------------------------------
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));

  // -------------------------------
  // ✅ Emotion Assessment Feature Setup
  // -------------------------------
  sl.registerLazySingleton<EmotionQuestionRemoteDataSource>(
    () => EmotionQuestionRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<EmotionQuestionRepository>(
    () => EmotionQuestionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => FetchEmotionQuestions(sl()));
  sl.registerFactory(() => EmotionQuestionCubit(sl()));
}
