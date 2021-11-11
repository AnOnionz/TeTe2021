
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tete2021/route/app_module.dart';
import '../../../../core/storage/hive_db.dart' as hive;
import 'package:asuka/asuka.dart' as asuka;
import 'package:tete2021/simple_bloc_observer.dart';
import 'package:wakelock/wakelock.dart';
import 'application.dart';

Future<void> main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await hive.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await Wakelock.enable();
    runApp(ModularApp(module: AppModule(), child: const App()));
  });
}

class App extends StatelessWidget {
   const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tê Tê SP",
      theme: ThemeData(
        fontFamily: 'helveticaneue',
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      builder: FlutterSmartDialog.init(builder: asuka.builder),
      home: const MyApplication(),
    ).modular();
  }
}
