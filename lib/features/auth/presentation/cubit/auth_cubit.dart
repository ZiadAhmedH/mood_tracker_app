import 'package:bloc/bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/email_pass_sign_up.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:moodtracker_app/features/auth/data/datasource/auth_local_data_source.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpEmailPassUseCase signUpUseCase;
  final LoginUserUseCase loginUseCase;
  final AuthLocalDataSource _authLocalDataSource = sl<AuthLocalDataSource>();

  AuthCubit(this.signUpUseCase, this.loginUseCase) : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      email: email,
      password: password,
      fullName: fullName,
    );

   result.fold(
  (failure) => emit(AuthError(failure)),
  (user) async {
    await _authLocalDataSource.cacheUserData(
      id: user.id,
      fullName: user.fullName!,
      email: user.email,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
    emit(AuthSuccess());
  },
);

  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) async {
        await _authLocalDataSource.cacheUserData(
          id: user.id,
          fullName: user.fullName!,
          email: user.email,
          createdAt: user.createdAt,
        );
        emit(AuthSuccess());
      },
    );
  }



}
