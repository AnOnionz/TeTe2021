import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import 'package:tete2021/features/home/presentation/blocs/dashboard_bloc.dart';
import 'package:tete2021/features/home/presentation/blocs/tab_bloc.dart';
import 'package:tete2021/features/home/presentation/widgets/bottom_bar.dart';
import 'package:tete2021/features/login/domain/entities/login_entity.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import 'package:tete2021/features/notifications/presentation/screens/notification_page.dart';
import 'package:tete2021/features/setting/presentation/screens/setting_page.dart';
import 'home_page.dart';

class DashboardPage extends StatelessWidget {
  final TabBloc _tabBloc = Modular.get<TabBloc>();
  final DashboardBloc _dashboardBloc = Modular.get<DashboardBloc>()
    ..add(SaveServerDataToLocalData());

  DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _itemBars = [
      HomePage(),
      const NotificationPage(),
      SettingPage()
    ];
    return WillPopScope(
      onWillPop: () async {
        // if (await Modular.get<SyncRepository>()
        //     .hasDataNonSync) {
        //   displayError(HasSyncFailure());
        //   return false;
        // }
        Modular.get<AuthenticationBloc>().add(ChangeOutlet());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg.png",
                  ), fit: BoxFit.cover,),
              ),
              child: BlocConsumer<DashboardBloc, DashboardState>(
                bloc: _dashboardBloc,
                listener: (context, state) {
                  if(state is DashboardChangeOutlet){
                    BlocProvider.of<AuthenticationBloc>(context).add(ChangeOutlet());
                  }
                  if (state is DashboardSaving) {
                      showLoading();
                  }
                  if (state is DashboardSaved) {
                    closeLoading();
                  }
                  if (state is DashboardFailure) {
                    closeLoading();
                    displayError(state.failure);
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<TabBloc, TabState>(
                    bloc: _tabBloc,
                    builder: (context, state) {
                      if (state is TabChanged) {
                        return _itemBars[state.index];
                      }
                      return const Scaffold(
                        body: Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                              animating: true,
                            )),
                      );
                    },
                  );
                },
              ),
            ), bottomNavigationBar: BottomBar(bloc: _tabBloc)
        ),
      ),
    );
  }
}
