import 'package:animate_do/animate_do.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/core/common/widgets/custom_loading.dart';
import 'package:tete2021/core/utils/toats.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import '../../core/error/failure.dart';

enum DialogType { box, shock }

extension DialogTypeExtension on DialogType {
  String get name => describeEnum(this);

  Image get iconDialog {
    switch (this) {
      case DialogType.box:
        return Image.asset(
          'assets/images/box1.png',
          height: 60,
          width: 60,
        );
      case DialogType.shock:
        return Image.asset(
          'assets/images/shock.png',
          height: 60,
          width: 60,
        );
      default:
        return Image.asset(
          'assets/images/shock.png',
          height: 60,
          width: 60,
        );
    }
  }
}

void showMessage({
  required String message,
  String? title,
  Color? titleColor,
  required DialogType type,
  List<Widget>? actionButtons,
}) async {
  await asuka.showDialog(
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: ZoomIn(
              duration: const Duration(milliseconds: 200),
              child: SimpleDialog(
                insetPadding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 24.0),
                contentPadding: const EdgeInsets.all(5),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
//Image.asset('assets/images/${type.name}.png'),
                            Center(
                              child: type.iconDialog,
                            ),
                            const SizedBox(height: 10,),
                            title != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      title,
                                      style: TextStyle(
                                          color: titleColor ?? Colors.black,
                                          fontSize: 20),
                                    )),
                                  )
                                : const SizedBox(
                                    height: 10,
                                  ),
                            Center(
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(message, style: kStyleBlack16, textAlign: TextAlign.center,)),
                            ),
                            const SizedBox(height: 10,),
                            actionButtons == null
                                ? InkWell(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                        child: const Center(
                                            child: Text(
                                          "Đồng ý",
                                          style: kStyleBlack16,
                                        )),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(

                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: const Color(0XFFEFEFEF),
                                        )),
                                  )
                                : Column(
                                    children: actionButtons,
                                  ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0XFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: const Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      });
}

void showWarning({required String message}){
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

void showLoading() {
  SmartDialog.showLoading(
    isLoadingTemp: false,
    widget: const CustomLoading(type: 1),
  );
}

void closeLoading() {
  SmartDialog.dismiss();
}

void displayMessage({required String message}) {
  showToast(message: message, color: const Color(0XFFFADBDD));
}

void displaySuccess({required String message}) {
  showToast(message: message, color: const Color(0XFFE7F5DD));
}
void displayWarning({required String message}) {
  showToast(message: message, color: const Color(0XFFF8D8D7));
}

void displayError(Failure failure) {
  if (failure is UnAuthenticateFailure) {
    asuka.showDialog(
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: ZoomIn(
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
                  onPressed: () {
                    Modular.get<AuthenticationBloc>().add(LoggedOut());
                    Modular.to.canPop() ? Modular.to.pop() : () {};
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  if (failure is InternetFailure) {
    showToast(
        message: failure.message,
        color: const Color(0XFFE3E1DF),
        icon: const Icon(
          Icons.wifi_off,
        ));
  } else {
    showToast(message: failure.message, color: const Color(0XFFF8D8D7));
  }
}
