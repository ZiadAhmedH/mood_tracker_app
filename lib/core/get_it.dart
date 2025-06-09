import 'package:get_it/get_it.dart';
import 'package:moodtracker_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:moodtracker_app/features/auth/domain/repo/sign_up_repo.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/email_pass_sign_up.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';
import 'package:moodtracker_app/features/profile/data/repo/user_repository_impl.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_cahed_User.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ✅ Shared Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);

  // ✅ Supabase Client
  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);

  // ✅ Local Data Source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // ✅ Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemote: sl(),),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => SignUpEmailPassUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));

  // ✅ Auth Cubit
  sl.registerFactory(() => AuthCubit(sl(), sl()));

  // ✅ Profile Feature Setup
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl( sl()),
  );

  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

  sl.registerFactory(() => ProfileCubit(sl()));
}
