import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/login/domain/entities/outlet_entity.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';

class OutletFound extends StatelessWidget {
  final OutletEntity outlet;
  final AuthenticationBloc bloc;
  const OutletFound({Key? key, required this.outlet, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            bloc.add(SelectOutlet(outletEntity: outlet));
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text(outlet.name ?? "", style: kStyleHomeHeader,),
              Text("Mã outlet: ${outlet.code}", style: kStyleBlack15,),
              Text("Địa chỉ: ${outlet.addressNumber} ${outlet.streetName} ${outlet.district} ${outlet.province}", style: kStyleBlack15,),
            ],),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
