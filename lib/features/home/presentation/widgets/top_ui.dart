import 'package:flutter/material.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/login/domain/entities/login_entity.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';

class TopUi extends StatelessWidget {
  const TopUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final outlet = AuthenticationBloc.outletEntity;
    final account = AuthenticationBloc.loginEntity;

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/logo.png",
                  height: 60,
                ),
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kGreenColor,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: const Center(
                      child: Text(
                    "PG",
                    style: kStyleWhite20,
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Text("VINMART Võ Thị Sáu",
                          style: kStyleHomeHeader, textAlign: TextAlign.center),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(3.0),
                    //   child: Text("Địa chỉ: ${outlet.addressNumber} ${outlet.streetName} ${outlet.district} ${outlet.province}", style: kStyleBlack15,textAlign: TextAlign.center),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Text("99 Võ Thị Sáu, Thanh Nhàn, Hai Bà Trưng", style: kStyleBlack16, textAlign: TextAlign.center),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
