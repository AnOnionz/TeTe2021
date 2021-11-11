import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

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
        body: const SizedBox()
      ),
    );
  }
}
