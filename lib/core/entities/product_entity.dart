import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../../core/common/keys.dart';
part 'product_entity.g.dart';

@HiveType(typeId: productId)
class ProductEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final String image;
  @HiveField(4)
  int? value;
  final TextEditingController controller;
  final FocusNode focus;

  ProductEntity({required this.id, required this.name, this.value, required this.image, required this.code}) : controller = TextEditingController(), focus = FocusNode();

  ProductEntity copy(){
    return ProductEntity(id : id, name: name, image: image, code: code, value: value);
  }
  factory ProductEntity.fromDetail(Map<String, dynamic> json){
    return ProductEntity(id: json["product_id"], name: "", image: "", code: "", value: json["qty"]);
  }

  factory ProductEntity.fromJson(Map<String, dynamic> json){
    return ProductEntity(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      image: json['image'],
    );
  }

  @override
  String toString() {
    return 'ProductEntity{id: $id, name: $name, code: $code, image: $image, value: $value, controller: $controller, focus: $focus}';
  }
}