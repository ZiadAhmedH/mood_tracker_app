import 'package:bloc/bloc.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/email_pass_sign_up.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/log_out_use_case.dart';
import 'package:moodtracker_app/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpEmailPassUseCase signUpUseCase;
  final LoginUserUseCase loginUseCase;
  final LogOutUseCase logOutUseCase;

  AuthCubit(this.signUpUseCase, this.loginUseCase,this.logOutUseCase) : super(AuthInitial());

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
        emit(AuthSuccess());
      },
    );
  }

  Future<void> logOut() async {
    emit(AuthLoggedOutLoading());

    final result = await logOutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure as String)),
      (user) async {
        emit(AuthLoggedOutSuccess());
      },
    );
  }



}
