import 'package:injectable/injectable.dart';
import '../../../../core/network/api_services.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers({
    required int limit,
    required int skip,
    String? gender,
  });
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiServices apiServices;

  UserRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<UserModel>> getUsers({
    required int limit,
    required int skip,
    String? gender,
  }) async {
    String endpoint = '/users';
    final Map<String, dynamic> queryParameters = {
      'limit': limit,
      'skip': skip,
    };

    if (gender != null && gender.isNotEmpty && gender != 'all') {
      endpoint = '/users/filter';
      queryParameters['key'] = 'gender';
      queryParameters['value'] = gender;
    }

    final response = await apiServices.call(
      ApiRequest.get(
        endpoint,
        queryParameters: queryParameters,
      ),
    );

    if (response['statusCode'] == 200) {
      final List<dynamic> usersJson = response['users'];
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to load users');
    }
  }
}
