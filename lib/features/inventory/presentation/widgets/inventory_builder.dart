import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/entities/data_local_entity.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/widgets/list_item.dart';
import '../../../../core/entities/product_entity.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/inventory/presentation/blocs/inventory_cubit.dart';
import '../../../../features/inventory/presentation/screens/inventory_page.dart';

class InventoryBuilder extends StatefulWidget {
  final InventoryType type;
  const InventoryBuilder({Key? key, required this.type}) : super(key: key);

  @override
  _InventoryBuilderState createState() => _InventoryBuilderState();
}

class _InventoryBuilderState extends State<InventoryBuilder> {
  final DashBoardLocalDataSource local =
  Modular.get<DashBoardLocalDataSource>();
  final InventoryCubit _cubit = Modular.get<InventoryCubit>();
  late DataLocalEntity? inventory;
  late List<ProductEntity> products;

  @override
  void initState() {
    super.initState();
    products = local.fetchProduct();
    inventory = widget.type == InventoryType.start ? local.dataToday.inventoryIn : local.dataToday.inventoryOut;
    if(inventory != null ){
      for (var element in products) {
        final ProductEntity? p = inventory!.data.firstWhereOrNull((e) => e.id == element.id);
        element.controller.text = p != null ? p.value.toString() : "" ;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(inventory);
    return products.isNotEmpty ? Column(
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
              child: BlocBuilder<InventoryCubit, InventoryState>(
                bloc: _cubit,
                builder: (context, state) {
                  return InkWell(
                    onTap: state is! InventoryLoading ? () async {
                      if(products.any((element) => element.controller.text.isEmpty)){
                        displayMessage(message: "Vui lòng nhập đầy đủ các trường bắt buộc");
                        return ;
                      }
                      _cubit.updateInventory(widget.type, products);

                    } : null,
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
                          : Center(
                          child: Text(
                            "Lưu tồn ${widget.type == InventoryType.start ? "đầu" : "cuối"} trên kệ",
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
        ]) : const SizedBox();
  }
}
