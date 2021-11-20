import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/core/platform/package_info.dart';
import 'package:tete2021/core/utils/dialogs.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import 'package:tete2021/features/login/presentation/blocs/login_bloc.dart';
import 'package:tete2021/features/sync_data/data/datasources/sync_local_data_source.dart';

class SettingPage extends StatelessWidget {
  final _bloc = Modular.get<LoginBloc>();

  SettingPage({Key? key}) : super(key: key);

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
            "Cá nhân",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Helvetica-regular',
                fontSize: 18),
          ),
          // leading: IconButton(
          //   onPressed: () {
          //     Modular.to.pop();
          //   },
          //   icon: Image.asset(
          //     "assets/images/back.png",
          //     color: Colors.black87,
          //     width: 30,
          //   ),
          // ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Chương trình",
                    style: kStyleBlack16,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    MyPackageInfo.appName,
                    style: kStyleBlack16,
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0XFFE8E8E8),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tài khoản đang đăng nhập",
                    style: kStyleBlack16,
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    AuthenticationBloc.loginEntity!.displayName,
                    style: kStyleBlack16,
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0XFFE8E8E8),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Đơn vị phát triển",
                    style: kStyleBlack16,
                  ),
                  SizedBox(height: 10,),
                  Text(
                   "iMark",
                    style: kStyleBlack16,
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0XFFE8E8E8),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Phiên bản",
                    style: kStyleBlack16,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    MyPackageInfo.version,
                    style: kStyleBlack16,
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0XFFE8E8E8),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<LoginBloc, LoginState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is LogoutLoading) {
                    return Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          radius: 20,
                        ),
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                        if(Modular.get<SyncLocalDataSource>().hasDataNonSync){
                          showWarning(message: "Yêu cầu đồng bộ trước khi đăng xuất");
                          return;
                        }
                      showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text("Đăng xuất ?"),
                          content: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Bạn có chắc muốn đăng xuất ?",
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
                                // if (await Modular.get<SyncRepository>()
                                //     .hasDataNonSync) {
                                //   displayError(HasSyncFailure());
                                //   return;
                                // }
                                Navigator.pop(context);
                                _bloc.add(Logout());
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:kRedColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(
                        child: Text(
                          "Đăng xuất",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
