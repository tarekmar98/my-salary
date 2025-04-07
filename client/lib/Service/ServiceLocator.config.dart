// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:client/Service/AuthUserService.dart' as _i168;
import 'package:client/Service/HttpService.dart' as _i657;
import 'package:client/Service/StorageService.dart' as _i83;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i168.AuthUserService>(() => _i168.AuthUserService());
    gh.factory<_i657.HttpService>(() => _i657.HttpService());
    gh.factory<_i83.StorageService>(() => _i83.StorageService());
    return this;
  }
}
