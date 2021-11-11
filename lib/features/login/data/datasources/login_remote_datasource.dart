import '../../../../features/login/data/model/login_model.dart';

import '../../../../core/api/myDio.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel> login({required String username, required String password});
  Future<bool> logout();
  Future<int?> getProjectId();
}
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource{
  final CDio cDio;

  LoginRemoteDataSourceImpl({required this.cDio});

  @override
  Future<LoginModel> login({required String username, required String password}) async {
    Map<String, dynamic> _requestBody = {
      'username': username,
      'password': password,
      'device_id': 'Null',
    };
    print("Login Request: $_requestBody");
    Response _resp = await cDio.postResponse(path:'auth/login', data: _requestBody);

    return LoginModel.fromJson(_resp.data['data']);
  }

  @override
  Future<bool> logout() async {
    return true;
  }

  @override
  Future<int?> getProjectId() async {
    Response _resp = await cDio.getResponse(path:'home/projects');
    if(_resp.data['data'] == []){
      return null;
    }
    return (_resp.data['data'] as List<dynamic>).first['id'];
  }


}