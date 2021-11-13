import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final int id;
  final String token;
  final String username;
  final String displayName;
  final String outletName;
  final String outletNameNoSymbol;
  final String address;
  final int limit;

  const LoginEntity({required this.id, required this.limit, required this.token, required this.username, required this.displayName, required this.address, required this.outletName, required this.outletNameNoSymbol});

  Map<String, dynamic> toJson() => {
    'id' : id ,
    'access_token' : token,
    'username': username,
    'display_name' : displayName,
    'outlet_name' : outletName,
    'outlet_name_no_symbol' : outletNameNoSymbol,
    'address': address,
    'limit': limit,
  };

  @override
  List<Object> get props => [id, token, username, displayName, outletName, outletNameNoSymbol, address, limit];

  @override
  String toString() {
    return 'LoginEntity{id: $id, token: $token, username: $username, displayName: $displayName, outletName: $outletName, outletNameNoSymbol: $outletNameNoSymbol, address: $address, limit: $limit}';
  }
}