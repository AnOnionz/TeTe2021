import 'package:flutter/material.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/platform/package_info.dart';
import '../../../../features/login/domain/entities/login_entity.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';

class TopUi extends StatelessWidget {
  const TopUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = AuthenticationBloc.loginEntity;

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
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
                  child: Center(
                      child: Column(
                    children: const [
                      Text(
                        "PG",
                        style: kStyleWhite20,
                      ),
                      Text(
                        MyPackageInfo.version,
                        style: kWhiteSmallSmallText,
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Text(account!.outletName,
                      style: kStyleHomeHeader, textAlign: TextAlign.center),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: Text("Địa chỉ: ${outlet.addressNumber} ${outlet.streetName} ${outlet.district} ${outlet.province}", style: kStyleBlack15,textAlign: TextAlign.center),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Text(account.address,
                      style: kStyleBlack16, textAlign: TextAlign.center),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
