import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../../core/common/keys.dart';
part 'product_entity.g.dart';

@HiveType(typeId: productId)
class ProductEntity extends HiveObject {
  @HiveField(0)
  final int index;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;
  @HiveField(3)
  int? value;
  final TextEditingController controller;
  final FocusNode focus;

  ProductEntity({required this.index, required this.name, this.value, required this.image}) : controller = TextEditingController(), focus = FocusNode();

  ProductEntity copy(){
    return ProductEntity(index : index, name: name, image: image, value: value);
  }

  @override
  String toString() {
    return 'ProductEntity{index: $index, name: $name, image: $image, value: $value}';
  }
}