import 'package:flutter/material.dart';
import 'package:tete2021/features/home/domain/entities/features.dart';

import 'feature_button.dart';
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final List items = <Feature>[Attendance(), SamplingInventory(), InventoryIn(), SamplingUse(), InventoryOut(), Sale(), Sync()];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: items.map((feature) => FeatureButton(feature: feature)).toList(),
      ),
    );
  }
}
