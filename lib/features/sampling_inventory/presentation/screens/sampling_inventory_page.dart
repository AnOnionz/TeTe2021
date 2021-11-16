// ignore_for_file: file_names

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tete2021/core/common/widgets/form_item.dart';
import 'package:tete2021/core/platform/package_info.dart';
import 'package:tete2021/features/sampling_inventory/data/datasources/sampling_inventory_local_data_source.dart';
import '../../../../core/common/constants.dart';
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
  final SamplingInventoryLocalDataSource samplingLocal =
  Modular.get<SamplingInventoryLocalDataSource>();
  final SamplingInventoryCubit _cubit = Modular.get<SamplingInventoryCubit>();
  late DataLocalEntity? _samplingInventory;
  late List<ProductEntity> products;
  late List<ProductEntity> products1;

  @override
  void initState() {
    super.initState();
    initData();
  }
  void initData(){
    products1 = local.fetchProduct();
    products = local.fetchProduct();
    _samplingInventory = samplingLocal.fetchSamplingInventory().lastOrNull ?? local.dataToday.samplingInventory;
    if(_samplingInventory != null){
      print(_samplingInventory);
      for (var element in products) {
        final ProductEntity? p = _samplingInventory!.data.firstWhereOrNull((e) => e.id == element.id);
        element.controller.text = p != null ? p.value != null ? p.value.toString()  : "0" : "0" ;
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
              "Nhập tồn sampling",
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
                    products1.mapIndexed((index, product) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                                child: Row(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: product.image,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) => Container(
                                        height: 100,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => const SizedBox(
                                        height: 100,
                                        width: 60,
                                        child: Center(
                                          child: CupertinoActivityIndicator(
                                            radius: 10,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => const SizedBox(
                                          height: 100,
                                          width: 60,
                                          child: Center(child: Icon(IconlyLight.dangerCircle))),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          product.name,
                                          style: kStyleRed16,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 120,
                                              child: FormItem(
                                                action: index == products1.length - 1 ? TextInputAction.done : TextInputAction.next,
                                                inputType: TextInputType.number,
                                                thisFocus: product.focus,
                                                nextFocus: index < products1.length - 1 ? products1[index +1].focus : null,
                                                onChanged: (p0) {
                                                  if (p0.isNotEmpty && int.parse(p0) == 0) {
                                                    product.controller.clear();
                                                  }
                                                },
                                                inputFormatter: <TextInputFormatter>[
                                                  LengthLimitingTextInputFormatter(5),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                                ],
                                                controller: product.controller,
                                                label: "Nhập" ,
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            SizedBox(
                                              width: 100,
                                              child: FormItem(
                                                controller: products.firstWhereOrNull((element) => element.id == product.id)!.controller,
                                                enable: false,
                                                label: "Tồn",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                    child: BlocConsumer<SamplingInventoryCubit, SamplingInventoryState>(
                      bloc: _cubit,
                      listener: (context, state) {
                        initData();
                        setState(() {

                        });
                      },
                      builder: (context, state) {
                        return InkWell(
                          onTap: state is! InventoryLoading ? () async {
                            if(products1.any((element) => element.controller.text.isEmpty)){
                              displayMessage(message: "Vui lòng nhập đầy đủ các trường bắt buộc");
                              return ;
                            }
                            _cubit.saveSamplingInventory(products1);
                          }: null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: 40.0,
                            width: state is InventoryLoading ? 40.0 : 800,
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
                                  state is InventoryLoading ? 40.0 : 5.0),
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
