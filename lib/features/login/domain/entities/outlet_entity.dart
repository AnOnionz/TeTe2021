import 'package:equatable/equatable.dart';

class OutletEntity extends Equatable {
  final int id;
  final String code;
  final String? name;
  final String? province;
  final String? district;
  final String? ward;
  final String? streetName;
  final String? addressNumber;

  const OutletEntity({ required this.id,  required this.code, this.name,  this.province,
    this.district, this.ward,  this.streetName,  this.addressNumber});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'province': province,
    'district': district,
    'ward': ward,
    'street_name': streetName,
    'address_number': addressNumber,
  };

  factory OutletEntity.fromJson(Map<String, dynamic> json) {
    return OutletEntity(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
      streetName: json['street_name'],
      addressNumber: json['address_number'],
    );
  }

  @override
  List<Object> get props => [id, code];

  @override
  String toString() {
    return 'OutletEntity{id: $id, code: $code, name: $name, province: $province, district: $district, ward: $ward, streetName: $streetName, addressNumber: $addressNumber}';
  }
}
