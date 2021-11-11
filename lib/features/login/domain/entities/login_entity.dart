import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final int id;
  final String token;
  final String username;
  final String fullName;
  final String? email;
  int? projectId;

  LoginEntity({required this.id, required this.token, required this.username, required this.fullName, this.email, this.projectId});

  Map<String, dynamic> toJson() => {
    'id' : id ,
    'access_token' : token,
    'username': username,
    'full_name': fullName,
    'email': email,
    'project_id': projectId,
  };

  @override
  List<Object> get props => [id, token, username, fullName];

  @override
  String toString() {
    return 'LoginEntity{id: $id, token: $token, username: $username, fullName: $fullName, email: $email, projectId: $projectId}';
  }
}