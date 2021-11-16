import 'dart:io';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/core/common/widgets/custom_loading.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import 'package:tete2021/features/home/data/datasources/dashboard_local_datasouce.dart';
import 'package:tete2021/features/home/presentation/blocs/dashboard_bloc.dart';
import 'package:tete2021/features/home/presentation/blocs/tab_bloc.dart';
import 'package:tete2021/features/home/presentation/widgets/bottom_bar.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import 'package:tete2021/features/notifications/presentation/blocs/notify_cubit.dart';
import 'package:tete2021/features/notifications/presentation/screens/notification_page.dart';
import 'package:tete2021/features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';
import 'package:tete2021/features/setting/presentation/screens/setting_page.dart';
import 'package:tete2021/features/sync_data/data/datasources/sync_local_data_source.dart';
import 'home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TabBloc _tabBloc = Modular.get<TabBloc>();
  final NotifyCubit _notifyCubit = Modular.get<NotifyCubit>()
    ..fetchNotify(0);
  final DashboardBloc _dashboardBloc = Modular.get<DashboardBloc>()
    ..add(SaveServerDataToLocalData());
  final DashBoardLocalDataSource local =
  Modular.get<DashBoardLocalDataSource>();
  final SamplingInventoryLocalDataSource samplingLocal =
  Modular.get<SamplingInventoryLocalDataSource>();
  late bool isShowBox = false;

  @override
  void initState() {
    initData();
    super.initState();
  }
  void initData(){
    final _samplingInventory = samplingLocal.fetchSamplingInventory().lastOrNull ?? local.dataToday.samplingInventory;
    if(_samplingInventory != null){
      print(samplingLocal.fetchSamplingInventory().lastOrNull);
      isShowBox = _samplingInventory.data.any((element) => element.value! < AuthenticationBloc.loginEntity!.limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _itemBars = [
      HomePage(isShowBox: isShowBox),
      const NotificationPage(),
      SettingPage()
    ];
    return WillPopScope(
      onWillPop: () async {
        if(Modular.get<SyncLocalDataSource>().hasDataNonSync){
          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text("Thoát ứng dụng ?"),
              content: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Có dữ liệu chưa đồng bộ, bạn có chắc muốn thoát ?",
                  style: kStyleBlack16,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("Hủy"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  textStyle: const TextStyle(color: Colors.red),
                  child: const Text("Xác nhận"),
                  onPressed: () async {
                    SystemNavigator.pop();
                    exit(0);
                  },
                ),
              ],
            ),
          );
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocConsumer<DashboardBloc, DashboardState>(
                bloc: _dashboardBloc,
                listener: (context, state) {
                  if(state is DashboardRefresh){
                    initData();
                    setState(() {
                    });
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
                        body: Center(child: CustomLoading(type: 1)),
                      );
                    },
                  );
                },
              ),
            ),
            bottomNavigationBar: BlocListener<NotifyCubit, NotifyState>(
              bloc: _notifyCubit,
              listener: (context, state) {
                if(state is NotifySuccess){
                  setState(() {});
                }
              },
              child: BottomBar(
                bloc: _tabBloc,
                isNewNotify: NotifyCubit.isNewNotify,
              ),
            )),
      ),
    );
  }
}
