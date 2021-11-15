import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tete2021/core/common/widgets/separator.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/platform/package_info.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/sync_data/data/datasources/sync_local_data_source.dart';
import '../../../../features/sync_data/domain/entities/sync_entity.dart';
import '../../../../features/sync_data/presentation/blocs/sync_data_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({Key? key}) : super(key: key);

  @override
  _SyncDataPageState createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  final SyncLocalDataSource local = Modular.get<SyncLocalDataSource>();
  final SyncDataBloc _bloc = Modular.get<SyncDataBloc>();
  late SyncEntity sync = local.getSync();
  late BuildContext dialogContext;

  List<Widget> getCat() {
    final list = [
      sync.isSamplingInventory
          ? const Text(
              "Nhập tồn sampling",
              style: kStyleGrey16,
              overflow: TextOverflow.ellipsis,
            )
          : const SizedBox(),
      sync.isInventoryIn
          ? const Text("Tồn đầu trên kệ",
              style: kStyleGrey16, overflow: TextOverflow.ellipsis)
          : const SizedBox(),
      sync.isSamplingUse
          ? const Text("Sampling sử dụng của ca",
              style: kStyleGrey16, overflow: TextOverflow.ellipsis)
          : const SizedBox(),
      sync.isInventoryOut
          ? const Text("Tồn cuối trên kệ",
              style: kStyleGrey16, overflow: TextOverflow.ellipsis)
          : const SizedBox(),
      sync.isSale
          ? const Text("Số bán theo ca",
              style: kStyleGrey16, overflow: TextOverflow.ellipsis)
          : const SizedBox(),
    ];
    int len = list.whereType<Text>().length;
    if (len > 1) {
      list.removeWhere((element) => element is SizedBox);
      var index = -1;
      for (int i = 1; i < len; i++) {
        index += 2;
        list.insert(
            index,
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: MySeparator(color: Color(0XFFC5C5C5)),
            ));
      }
    }
    print(list);
    return list;
  }
  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(sync);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Đồng bộ dữ liệu",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Helvetica-regular',
                  fontSize: 18),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: Text(MyPackageInfo.version, style: kStyleBlack14,)),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: local.hasDataNonSync
                          ? Image.asset("assets/images/sync_box.png")
                          : Image.asset("assets/images/sync_box_null.png"),
                    ),
                    local.hasDataNonSync
                        ? const Text(
                            "Có dữ liệu offline, hãy đồng bộ ngay nhé",
                            style: kStyleBlack16,
                          )
                        : const Text(
                            "Không có dữ liệu offline",
                            style: kStyleBlack16,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<SyncDataBloc, SyncDataState>(
                      bloc: _bloc,
                      builder: (context, state) {
                        if (state is SyncDataLoading) {
                          return
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                    MediaQuery.of(context).size.width * .8),
                                child:  const LinearProgressIndicator(
                                  backgroundColor: Color(0xFFF5F5F5),
                                  color: kRedColor,
                                  minHeight: 8,
                                ));

                        }
                        return ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .6),
                            child: Column(children: getCat()));
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: BlocConsumer<SyncDataBloc, SyncDataState>(
                    bloc: _bloc,
                    listener: (context, state) {
                      if (state is SyncDataSuccess) {
                        setState(() {
                          sync = state.syncEntity;
                        });
                        displaySuccess(message: "Đồng bộ hoàn tất");
                      }
                      if (state is SyncDataFailure) {
                        setState(() {
                          sync = local.getSync();
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is SyncDataLoading) {
                        return const SizedBox();
                      }
                      return InkWell(
                        onTap: local.hasDataNonSync
                            ? () async {
                                _bloc.add(SyncStart());
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 40.0,
                          width: 800,
                          child: Center(
                              child: Text(
                            "Đồng bộ",
                            style: local.hasDataNonSync
                                ? kStyleWhite17
                                : const TextStyle(
                                    color: Color(0xFFA5A5A5), fontSize: 17),
                          )),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: local.hasDataNonSync
                                ? kRedColor
                                : const Color(0xFFEFEFEF),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}
