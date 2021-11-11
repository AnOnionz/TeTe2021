import 'package:tete2021/features/login/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required int id,
    required String token,
    required String userName,
    required String fullName,
    String? email,
    int? projectId,
  }) : super(
      id: id,
      token: token,
      fullName: fullName,
      username: userName,
      email: email,
      projectId: projectId);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as int,
      token: json['access_token'],
      userName: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      projectId: json['project_id'],
    );
  }
}
