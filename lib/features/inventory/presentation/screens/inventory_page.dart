import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../features/home/data/datasources/dashboard_local_datasouce.dart';
import '../../../../features/inventory/presentation/widgets/inventory_builder.dart';

enum InventoryType { start, end, sale }

class InventoryPage extends StatelessWidget {
  final DashBoardLocalDataSource local =
      Modular.get<DashBoardLocalDataSource>();
  final InventoryType type;
  InventoryPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   FocusScopeNode currentFocus = FocusScope.of(context);
      //   if (!currentFocus.hasPrimaryFocus) {
      //     currentFocus.unfocus();
      //   }
      // },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Tồn ${type == InventoryType.start ? "đầu" : "cuối"} trên kệ",
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Helvetica-regular',
                  fontSize: 18),
            ),
          ),
          body: InventoryBuilder(type: type,),
        ),
      ),
    );
  }
}
