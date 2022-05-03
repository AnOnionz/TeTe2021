import 'package:flutter/material.dart';
import '../../../../features/home/domain/entities/features.dart';

import 'feature_button.dart';
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final List items = <Feature>[Attendance(), SamplingInventory(), InventoryIn(), SamplingUse(), InventoryOut(), Sale(), Survey(), Sync()];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: items.map((feature) => FeatureButton(feature: feature)).toList(),
      ),
    );
  }
}
