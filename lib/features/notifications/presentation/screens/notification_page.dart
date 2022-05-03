import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/widgets/custom_loading.dart';
import '../../../../core/platform/package_info.dart';
import '../../../../features/notifications/presentation/blocs/notify_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final NotifyCubit _cubit = Modular.get<NotifyCubit>()..fetchNotify(1);

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _cubit.refreshData(1);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Thông báo của bạn",
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
          body: Container(
            color: kBackgroundColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<NotifyCubit, NotifyState>(
                    bloc: _cubit,
                    builder: (context, state) {
                      if (state is NotifyFailure) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _cubit.fetchNotify(1);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                child: Text(
                                  "Không thể tải, nhấn để thử lại",
                                  style: kStyleGrey14,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      if (state is NotifySuccess) {
                        return LiquidPullToRefresh(
                          key: _refreshIndicatorKey, // key if you want to add
                          onRefresh: _onRefresh,
                          showChildOpacityTransition: false,
                          backgroundColor: kRedColor,
                          color: Colors.transparent,
                          springAnimationDurationInMilliseconds: 1,
                          child: state.notifies.isNotEmpty
                              ? ListView(
                                  children: state.notifies
                                      .map((e) => Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            decoration: BoxDecoration(
                                                color: e.isNew
                                                    ? const Color(0XFFFFFAFA)
                                                    : Colors.white,
                                                border: const Border(
                                                  bottom: BorderSide(width: 1.5, color: Color(0xFFE8E8E8))
                                                ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e.title,
                                                        style: kStyleBlack20,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        e.body,
                                                        style: kStyleBlack17,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(DateFormat(
                                                              "HH:mm dd/MM/yyyy")
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  e.createdAt *
                                                                      1000)))
                                                    ],
                                                  ),
                                                ),
                                                e.isNew
                                                    ? Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kRedColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                )
                              : const Center(
                                  child: Text(
                                      "Bạn chưa nhận được thông báo nào"),
                                ),
                        );
                      }
                      return const Center(child: CustomLoading(type: 1));
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
