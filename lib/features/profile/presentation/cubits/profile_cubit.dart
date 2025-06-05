// presentation/cubit/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/features/auth/domain/entities/user.dart';
import 'package:moodtracker_app/features/profile/domain/usecases/get_cahed_User.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_state.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final GetCachedUserUseCase getCachedUserUseCase;

  ProfileCubit(this.getCachedUserUseCase) : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    final result = await getCachedUserUseCase();
    result.fold(
      (failure) => emit(ProfileError(failure)),
      (user) => emit(ProfileLoaded(User(
        id: user!.id,
        email: user.email,
        createdAt: user.createdAt,
        fullName: user.fullName,
      ))),
    );
  }
}
