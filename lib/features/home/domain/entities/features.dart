import 'package:flutter/material.dart';

class Feature {
  final Image image;
  final String label;
  final String nextRoute;

  const Feature({required this.image, required this.label,required this.nextRoute});

}
class Attendance extends Feature {
  Attendance() : super (image: Image.asset("assets/images/clock.png", height: 40,), label: "Chấm công", nextRoute: '/attendance');
}
class InventoryIn extends Feature {
  InventoryIn() : super (image: Image.asset("assets/images/box.png", height: 40,),label: "Tồn đầu trên kệ", nextRoute: '/inventory_in');
}
class InventoryOut extends Feature {
  InventoryOut() : super (image: Image.asset("assets/images/box.png", height: 40,),label: "Tồn cuối trên kệ", nextRoute: '/inventory_out');
}
class Sale extends Feature {
  Sale() : super (image: Image.asset("assets/images/tag.png", height: 40,),label: "Số bán theo ca", nextRoute: '/sale');
}
class SamplingInventory extends Feature {
  SamplingInventory() : super (image: Image.asset("assets/images/box.png", height: 40,),label: "Nhập tồn sampling", nextRoute: '/sampling_inventory');
}
class SamplingUse extends Feature {
  SamplingUse() : super (image: Image.asset("assets/images/hand.png", height: 40,),label: "Sampling sử dụng của ca", nextRoute: '/sampling_use');
}
class Sync extends Feature {
  Sync() : super (image: Image.asset("assets/images/cloud.png", height: 40,),label: "Đồng bộ", nextRoute: '/sync');
}
class Survey extends Feature {
  Survey() : super (image: Image.asset("assets/images/google-forms.png", height: 40,),label: "Khảo sát", nextRoute: '/survey');
}



