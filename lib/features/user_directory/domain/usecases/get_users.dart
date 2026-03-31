import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call({
    required int limit,
    required int skip,
    String? gender,
  }) async {
    return await repository.getUsers(
      limit: limit,
      skip: skip,
      gender: gender,
    );
  }
}
