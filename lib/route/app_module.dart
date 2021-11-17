import 'package:flutter_modular/flutter_modular.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/platform/network_info.dart';
import '../core/api/myDio.dart';
import 'home_module.dart';

class AppModule extends Module {

  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => CDio()),
    Bind.lazySingleton((i) => NetworkInfoImpl(i.get<InternetConnectionChecker>())),
  ];
  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: HomeModule(), transition: TransitionType.rightToLeftWithFade, duration: const Duration(milliseconds: 0)),
  ];

}