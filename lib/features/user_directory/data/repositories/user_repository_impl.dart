import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers({
    required int limit,
    required int skip,
    String? gender,
  }) async {
    return await remoteDataSource.getUsers(
      limit: limit,
      skip: skip,
      gender: gender,
    );
  }
}
