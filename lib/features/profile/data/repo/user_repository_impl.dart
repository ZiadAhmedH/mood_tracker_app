import 'package:moodtracker_app/features/auth/data/repository/auth_local_data_source_impl.dart';
import 'package:moodtracker_app/features/profile/domain/entities/user.dart';
import 'package:moodtracker_app/features/profile/domain/repo/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

 @override
Future<User?> getCachedUser() async {
  final cached = await localDataSource.getCachedUserData();
  if (cached == null) return null;

  print('Cached map inside repository: $cached'); // Add this

  return User.fromJson({
    'id': cached['id'],
    'fullName': cached['fullName'],  // Must be 'fullName'
    'email': cached['email'],
    'createdAt': cached['createdAt'],
    'avatarUrl': cached['avatarUrl'] ?? '',
  });
}

}
