// ignore_for_file: file_names

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/widgets/list_item.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/inventory/presentation/blocs/inventory_cubit.dart';
import '../../../../features/sampling_inventory/presentation/blocs/sampling_inventory_cubit.dart';
import '../../../../features/sampling_use/presentation/screens/sampling%20_use_page.dart';


class SamplingInventoryPage extends StatefulWidget {
  final SamplingType type;

  const SamplingInventoryPage({Key? key, required this.type}) : super(key: key);

  @override
  State<SamplingInventoryPage> createState() => _SamplingInventoryPageState();
}

class _SamplingInventoryPageState extends State<SamplingInventoryPage> {
  final DashBoardLocalDataSource local =
  Modular.get<DashBoardLocalDataSource>();
  final SamplingInventoryCubit _cubit = Modular.get<SamplingInventoryCubit>();
  late DataLocalEntity? _samplingInventory;
  late List<ProductEntity> products;

  @override
  void initState() {
    super.initState();
    products = local.fetchProduct();
    _samplingInventory = local.dataToday.samplingInventory;
    if(_samplingInventory != null ){
      for (var element in products) {
        final ProductEntity? p = _samplingInventory!.data.firstWhereOrNull((e) => e.index == element.index);
        element.controller.text = p != null ? p.value.toString() : "" ;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Nhập tồn sampling",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Helvetica-regular',
                  fontSize: 18),
            ),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children:
                    products.mapIndexed((index, product) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListItem(
                            action: index == products.length - 1 ? TextInputAction.done : TextInputAction.next,
                            nextFocus: index < products.length - 1 ? products[index +1].focus : null,
                            product: product,
                            type: widget.type,
                          ),
                        ),
                        const Divider(color: Color(0XFFC5C5C5), height: 1, thickness: 1,),
                      ],
                    )).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: BlocBuilder<SamplingInventoryCubit, SamplingInventoryState>(
                      bloc: _cubit,
                      builder: (context, state) {
                        return InkWell(
                          onTap: () async {
                            print(products.map((e) => e.controller.text));
                            if(products.any((element) => element.controller.text.isEmpty)){
                              displayMessage(message: "Vui lòng nhập đầy đủ các trường bắt buộc");
                              return ;
                            }
                            _cubit.saveSamplingInventory(products);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: 40.0,
                            width: state is InventoryLoading ? 48.0 : 800,
                            child: state is InventoryLoading
                                ? Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(3.0),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Colors.white))),
                            )
                                : const Center(
                                child: Text(
                                  "Lưu tồn sampling",
                                  style: kStyleWhite17,
                                )),
                            padding: EdgeInsets.symmetric(
                                horizontal: state is InventoryLoading ? 0 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  state is InventoryLoading ? 48.0 : 5.0),
                              color: kRedColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
