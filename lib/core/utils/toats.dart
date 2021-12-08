import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asuka/asuka.dart' as asuka;
import '../../../../core/common/widgets/custom_toast.dart';

void showToast({required String message, required Color color, Icon? icon}){
  SmartDialog.dismiss(status: SmartStatus.toast);
  SmartDialog.showToast('', time: const Duration(milliseconds: 1500), widget: CustomToast(msg: message, color: color, icon: icon,));
}