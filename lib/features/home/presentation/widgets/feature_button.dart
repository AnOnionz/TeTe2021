import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/toats.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/home/domain/entities/features.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';

class FeatureButton extends StatelessWidget {
  final Feature feature;
  final DashBoardLocalDataSource local =
      Modular.get<DashBoardLocalDataSource>();
  FeatureButton({Key? key, required this.feature}) : super(key: key);

  final AuthenticationBloc bloc = Modular.get<AuthenticationBloc>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
          onTap: () async {
            if (!local.dataToday.isCheckIn && feature is! Attendance && feature is! Sync ) {
              displayMessage(message: 'Yêu cầu chấm công');
              return;
            }
            if(local.dataToday.inventoryIn == null && feature is Sale ){
              displayMessage(message: 'Yêu cầu nhập tồn đầu');
              return;
            }
            if(local.dataToday.inventoryOut == null && feature is Sale ){
              displayMessage(message: 'Yêu cầu nhập tồn cuối');
              return;
            }
            Modular.to.pushNamed(feature.nextRoute);
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: kRedColor)),
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  decoration:const BoxDecoration(
                      color: kRedColor,
                      ),
                  child: feature.image,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    feature.label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kStyleBlack18,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
