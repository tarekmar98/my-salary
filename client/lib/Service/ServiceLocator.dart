import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'ServiceLocator.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() => getIt.init();
