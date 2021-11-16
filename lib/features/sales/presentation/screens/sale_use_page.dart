// ignore_for_file: file_names
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/platform/package_info.dart';
import 'package:tete2021/features/inventory/presentation/screens/inventory_page.dart';
import 'package:tete2021/features/sales/presentation/blocs/sale_cubit.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/widgets/list_item.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/sampling_use/presentation/blocs/sampling_use_cubit.dart';

class SalePage extends StatefulWidget {

  const SalePage({Key? key}) : super(key: key);

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final DashBoardLocalDataSource local =
      Modular.get<DashBoardLocalDataSource>();
  final SaleCubit _cubit = Modular.get<SaleCubit>();
  late List<ProductEntity> products;

  @override
  void initState() {
    super.initState();
    products = local.fetchProduct();
    final inventoryIn = local.dataToday.inventoryIn;
    final inventoryOut = local.dataToday.inventoryOut;
    if(inventoryIn != null && inventoryOut != null){
      for (var element in products) {
        final ProductEntity? invIn = inventoryIn.data.firstWhereOrNull((e) => e.id == element.id);
        final ProductEntity? invOut = inventoryOut.data.firstWhereOrNull((e) => e.id == element.id);
        if(invIn != null && invOut !=null){
          element.controller.text = (invIn.value! - invOut.value!).toString();
        }
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
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Số bán theo ca",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Helvetica-regular',
                  fontSize: 18),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: Text(MyPackageInfo.version, style: kStyleBlack14,)),
              )
            ],
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
                            type: InventoryType.sale,
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
                    child: BlocBuilder<SaleCubit, SaleState>(
                      bloc: _cubit,
                      builder: (context, state) {
                        return InkWell(
                          onTap: state is! SaleLoading ? () async {
                            if(products.any((element) => element.controller.text.isEmpty)){
                              displayMessage(message: "Vui lòng nhập đầy đủ các trường bắt buộc");
                              return ;
                            }
                            _cubit.saveSale(products);
                          }: null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: 40.0,
                            width: state is SaleLoading ? 48.0 : 800,
                            child: state is SaleLoading
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
                                    "Lưu số bán theo ca",
                                    style: kStyleWhite17,
                                  )),
                            padding: EdgeInsets.symmetric(
                                horizontal: state is SaleLoading ? 0 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  state is SaleLoading ? 48.0 : 5.0),
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
