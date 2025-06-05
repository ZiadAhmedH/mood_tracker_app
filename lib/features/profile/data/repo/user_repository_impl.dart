import 'package:moodtracker_app/features/profile/data/models/user_model.dart';
import 'package:moodtracker_app/features/profile/domain/entities/user.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';
import 'package:moodtracker_app/features/auth/data/datasource/auth_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<User?> getCachedUser() async {
    final cached = await localDataSource.getCachedUserData();
    if (cached == null) return null;

    return UserModel.fromJson(cached);
  }
}
