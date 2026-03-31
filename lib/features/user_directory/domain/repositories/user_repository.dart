import '../../domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers({
    required int limit,
    required int skip,
    String? gender,
  });
}
