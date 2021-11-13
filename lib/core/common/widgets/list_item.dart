import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/core/common/widgets/separator.dart';
import 'package:tete2021/core/entities/product_entity.dart';
import 'package:tete2021/features/inventory/presentation/screens/inventory_page.dart';
import 'package:tete2021/features/sampling_use/presentation/screens/sampling%20_use_page.dart';

import 'form_item.dart';

class ListItem extends StatelessWidget {
  final FocusNode? nextFocus;
  final TextInputAction? action;
  final ProductEntity product;
  final dynamic type;
  const ListItem({Key? key, required this.product, this.type, this.nextFocus, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
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
              Expanded(
                child: SizedBox(
                  width: min(MediaQuery.of(context).size.width / 2, 200),
                  child: FormItem(
                    action: action,
                    inputType: TextInputType.number,
                    thisFocus: product.focus,
                    nextFocus: nextFocus,
                    inputFormatter: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(5),
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    controller: product.controller,
                    label: type == InventoryType.start
                        ? "Tồn đầu trên kệ"
                        : type == InventoryType.end
                            ? "Tồn cuối trên kệ"
                            : type == SamplingType.use
                                ? "Sampling sử dụng"
                                : type == SamplingType.inventory ? "Nhập" : type == InventoryType.start ? "Số bán theo ca" : "",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
