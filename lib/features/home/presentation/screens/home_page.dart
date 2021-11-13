import 'package:collection/src/iterable_extensions.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/home/data/datasources/dashboard_local_datasouce.dart';
import 'package:tete2021/features/home/presentation/widgets/feature_grid.dart';
import 'package:tete2021/features/home/presentation/widgets/top_ui.dart';
import 'package:tete2021/features/login/domain/entities/login_entity.dart';
import 'package:tete2021/features/login/presentation/blocs/authentication_bloc.dart';
import 'package:tete2021/features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';

class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final DashBoardLocalDataSource local =
    Modular.get<DashBoardLocalDataSource>();
    final SamplingInventoryLocalDataSource samplingLocal =
    Modular.get<SamplingInventoryLocalDataSource>();
    late bool isShowBox = false;

    @override
  void initState() {
    super.initState();
    initData();
  }

    void initData(){
      final _samplingInventory = samplingLocal.fetchSamplingInventory().lastOrNull ?? local.dataToday.samplingInventory;
      if(_samplingInventory != null){
        print(AuthenticationBloc.loginEntity!.limit);
        isShowBox = _samplingInventory.data.any((element) => element.value! < AuthenticationBloc.loginEntity!.limit);
      }
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const TopUi(),
        isShowBox ? Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          child: Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 15, 30, 15),
                decoration: DottedDecoration(
                    strokeWidth: 2,
                    dash: const [6, 6],
                    shape: Shape.box,
                    color: kRedColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/images/box1.png", height: 32,),
                    const SizedBox(width: 10.0,),
                   const Expanded(child: Text("Tồn sampling đang nhỏ hơn mức quy định. Hãy nhập thêm hàng", style: kStyleBlack14,)),
                  ],
                )),
          ),
        ) : const SizedBox(),
        const Expanded(child: FeatureGrid()),
      ],
    );
  }
}
