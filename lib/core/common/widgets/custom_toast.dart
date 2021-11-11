import 'package:flutter/material.dart';
import 'package:tete2021/core/common/constants.dart';

class CustomToast extends StatelessWidget {
  final String msg;
  final Color color;
  final Icon? icon;

  const CustomToast({Key? key,required this.msg, required this.color, this.icon}): super(key: key);



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 35,
        margin: const EdgeInsets.only(bottom: 80),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: icon ?? const SizedBox(),
          ),
          //msg
          Text(msg, style: kStyleBlack15),
        ]),
      ),
    );
  }

}