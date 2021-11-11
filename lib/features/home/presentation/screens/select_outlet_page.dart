import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/home/presentation/blocs/fetch_outlet_cubit.dart';
import 'package:tete2021/features/home/presentation/widgets/outlet_found.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import 'package:tete2021/features/login/presentation/blocs/login_bloc.dart';
import 'package:tete2021/features/login/presentation/widgets/auth_button.dart';

class SelectOutletPage extends StatelessWidget {
  SelectOutletPage({Key? key}) : super(key: key);
  final FetchOutletCubit _cubit = Modular.get<FetchOutletCubit>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        asuka.showDialog(
          builder: (context) =>
              CupertinoAlertDialog(
                title: const Text(
                  'Bạn có chắc muốn tắt ứng dụng?',
                  style: kStyleBlack17,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text(
                        'Hủy',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () => Navigator.of(context).pop(false)),
                  CupertinoDialogAction(
                    textStyle: const TextStyle(color: Colors.red),
                    isDefaultAction: true,
                    child: const Text(
                      'Đồng ý',
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                      exit(0);
                    },
                  ),
                ],
              ),
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Danh sách Outlet",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Helvetica-regular',
                  fontSize: 18),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: kBackgroundColor,
                  child: TextFormField(
                    controller: _controller,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica-regular',
                        color: Colors.black),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Mã outlet',
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Helvetica-regular',
                          color: Colors.black.withOpacity(0.5)),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: BlocBuilder<FetchOutletCubit, FetchOutletState>(
                        bloc: _cubit,
                        builder: (context, state) {
                          if(state is FetchOutletLoading){
                            return const IconButton(
                                icon: SizedBox(height: 20, width: 20,child: CircularProgressIndicator(color: kOrangeColor, strokeWidth: 2.5,)),
                                onPressed: null);
                          }
                          return IconButton(
                              icon: const Icon(Icons.search,
                                  color: Colors.black, size: 25),
                              onPressed: () {
                                _cubit.find(_controller.text);
                              });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Color(0XFFEDEDED)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                        const BorderSide(color: Color(0XFFEDEDED)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        gapPadding: double.infinity,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: BlocBuilder<FetchOutletCubit, FetchOutletState>(
                    bloc: _cubit,
                    builder: (context, state) {
                      if (state is FetchOutletFailure) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/box.png"),
                            const SizedBox(height: 10,),
                            const Text(
                              "Không tìm thấy outlet",
                              style: kStyleGrey14,
                            )
                          ],
                        );
                      }
                      if (state is FetchOutletSuccess) {
                        return OutletFound(outlet: state.outlet,
                            bloc: context.read<AuthenticationBloc>());
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                AuthButton(bloc: context.read<LoginBloc>(),
                  title: "Đăng xuất",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (iContext) => CupertinoAlertDialog(
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
                              Navigator.pop(iContext);
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
                              Navigator.pop(iContext);
                              context.read<AuthenticationBloc>().add(LoggedOut());
                            },
                          ),
                        ],
                      ),
                    );

                  },),
                //const OutletFound(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
