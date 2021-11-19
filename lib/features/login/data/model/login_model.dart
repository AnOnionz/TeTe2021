import 'package:tete2021/features/login/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required int id,
    required String token,
    required String userName,
    required String displayName,
    required String outletName,
    required String outletNameNoSymbol,
    required String address,
    required int limit,
    required String surveyLink

  }) : super(
      id: id,
      token: token,
      displayName: displayName,
      username: userName,
      outletName: outletName,
      outletNameNoSymbol: outletNameNoSymbol,
      address: address,
      limit: limit,
      surveyLink: surveyLink
  );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as int,
      token: json['access_token'],
      userName: json['username'],
      displayName: json['display_name'],
      outletName: json['outlet_name'],
      outletNameNoSymbol: json['outlet_name_no_symbol'],
      address: json['address'],
      limit: json['limit'],
      surveyLink: json['survey_link'],
    );
  }
}
