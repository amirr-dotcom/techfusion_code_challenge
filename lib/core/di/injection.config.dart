// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/user_directory/data/datasources/user_remote_data_source.dart'
    as _i830;
import '../../features/user_directory/data/repositories/user_repository_impl.dart'
    as _i162;
import '../../features/user_directory/domain/repositories/user_repository.dart'
    as _i247;
import '../../features/user_directory/domain/usecases/get_users.dart' as _i422;
import '../../features/user_directory/presentation/bloc/user_bloc.dart' as _i52;
import '../bloc/theme_bloc.dart' as _i920;
import '../network/api_services.dart' as _i804;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i920.ThemeBloc>(() => _i920.ThemeBloc());
    gh.lazySingleton<String>(
      () => registerModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.lazySingleton<_i804.ApiServices>(
      () => _i804.ApiServices(gh<String>(instanceName: 'baseUrl')),
    );
    gh.lazySingleton<_i830.UserRemoteDataSource>(
      () =>
          _i830.UserRemoteDataSourceImpl(apiServices: gh<_i804.ApiServices>()),
    );
    gh.lazySingleton<_i247.UserRepository>(
      () => _i162.UserRepositoryImpl(
        remoteDataSource: gh<_i830.UserRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i422.GetUsers>(
      () => _i422.GetUsers(gh<_i247.UserRepository>()),
    );
    gh.factory<_i52.UserBloc>(
      () => _i52.UserBloc(getUsers: gh<_i422.GetUsers>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
