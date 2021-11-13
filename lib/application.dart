import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:wakelock/wakelock.dart';
import 'features/home/presentation/screens/dashboard_page.dart';
import 'features/login/presentation/blocs/authentication_bloc.dart';
import 'features/login/presentation/blocs/login_bloc.dart';
import 'features/login/presentation/screens/login_page.dart';

class MyApplication extends StatefulWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  _MyApplicationState createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  final AuthenticationBloc _authenticationBloc =
      Modular.get<AuthenticationBloc>()..add(AppStarted());
  final LoginBloc _loginBloc = Modular.get<LoginBloc>();
  final globalKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Modular.get<CDio>().setHeader(MyPackageInfo.versionCode);
  }

  @override
  void dispose() {
    Hive.close();
    Wakelock.disable();
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (_) => _authenticationBloc),
          BlocProvider<LoginBloc>(create: (_) => _loginBloc),
        ],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUnauthenticated) {
              return LoginPage();
            }
            if (state is AuthenticationAuthenticated) {
              return DashboardPage();
            }
            return Scaffold(
              body: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                      child: CupertinoActivityIndicator(
                    radius: 20,
                    animating: true,
                  ))),
            );
          },
        ),
      ),
    );
  }
}
