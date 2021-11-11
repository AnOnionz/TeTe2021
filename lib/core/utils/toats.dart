import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:tete2021/core/common/widgets/custom_toast.dart';

void showToast({required String message, required Color color, Icon? icon}){
  SmartDialog.showToast('', widget: CustomToast(msg: message, color: color, icon: icon,));
}