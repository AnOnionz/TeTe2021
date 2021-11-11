import 'package:animate_do/animate_do.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/core/common/widgets/custom_loading.dart';
import 'package:tete2021/core/utils/toats.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import '../../core/error/failure.dart';


void showMessage({required String message}){
    asuka.showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
      builder: (BuildContext context) {
        return ZoomIn(
          duration: const Duration(milliseconds: 100),
          child: CupertinoAlertDialog(
            title: const Text("Thông báo"),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: kStyleBlack17,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text("Đóng"),
                onPressed:() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
  }
void showLoading(){
  SmartDialog.showLoading(
    isLoadingTemp: false,
    widget: const CustomLoading(type: 1),
  );
}
void closeLoading(){
  SmartDialog.dismiss();
}
void displayMessage({required String message}){
  showToast(message: message, color: const Color(0XFFFADBDD));
}
void displaySuccess({required String message}){
  showToast(message: message, color: const Color(0XFFE7F5DD));
}
void displayError(Failure failure){
  if(failure is UnAuthenticateFailure) {
      asuka.showDialog(
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child:
            ZoomIn(
              duration: const Duration(milliseconds: 100),
              child: CupertinoAlertDialog(
                title: const Text("Thông báo"),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    failure.message,
                    style: kStyleBlack17,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Đăng nhập"),
                    onPressed:() {
                      Modular.get<AuthenticationBloc>().add(LoggedOut());
                      Modular.to.canPop()?Modular.to.pop() : (){};
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },);
  }
  if(failure is InternetFailure){
    showToast(message: failure.message, color: const Color(0XFFE3E1DF), icon: const Icon(Icons.wifi_off,));
  }else{
    showToast(message: failure.message, color: const Color(0XFFF8D8D7));
  }

}
