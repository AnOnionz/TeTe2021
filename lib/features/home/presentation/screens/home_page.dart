import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tete2021/core/common/constants.dart';
import 'package:tete2021/features/home/presentation/widgets/feature_grid.dart';
import 'package:tete2021/features/home/presentation/widgets/top_ui.dart';


class HomePage extends StatelessWidget {
  final bool isShowBox;
  const HomePage({Key? key, required this.isShowBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const TopUi(),
        isShowBox
            ? Padding(
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
                          Image.asset(
                            "assets/images/box1.png",
                            height: 32,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Expanded(
                              child: Text(
                            "Tồn sampling đang nhỏ hơn mức quy định. Hãy nhập thêm hàng",
                            style: kStyleBlack14,
                          )),
                        ],
                      )),
                ),
              )
            : const SizedBox(),
        const Expanded(child: FeatureGrid()),
      ],
    );
  }
}
