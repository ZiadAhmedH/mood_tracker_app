// presentation/cubit/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_state.dart';

import '../../../auth/data/models/user_model.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final AuthLocalDataSource localDataSource;

  ProfileCubit(this.localDataSource) : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());

    final cached = await localDataSource.getCachedUserData();
    if (cached == null) {
      emit(ProfileError('No cached user data found'));
      return;
    }

    final fullName = cached['fullName'] ?? '';
    final email = cached['email'] ?? '';
    final id = cached['id'] ?? '';
    final createdAt = cached['createdAt'] ?? '';

    print('[ProfileCubit] Cached data: $cached');

    emit(ProfileLoaded(
       UserModel(
        id: id,
        fullName: fullName,
        email: email,
        createdAt: createdAt,
      ),
    ));
  }
}

