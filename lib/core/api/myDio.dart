// ignore_for_file: file_names
import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/error/Exception.dart';
export 'package:dio/dio.dart';

class CDio {
   static const String apiBaseUrl = 'https://tete.imark.vn';
   static const String apiPath = 'api';
   late final Dio client;

  CDio(){
    client = Dio(BaseOptions(
      baseUrl: '$apiBaseUrl/$apiPath/',
      connectTimeout: 20000,
      receiveTimeout: 20000,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (status) => true,
      receiveDataWhenStatusError: true,
    ),);
  }

  Future<Response> getResponse({required String path, Map<String, dynamic>? data}) async {
    try {
      print('GET ${client.options.baseUrl}$path');
      final response = await client.get(path, queryParameters: data);
       print('GET $path: ${response.data}');
        if (response.statusCode == 200 && response.data['success'] == true) {
          return response;
        }
        if (response.statusCode == 403 || response.statusCode == 401) {
          throw(UnAuthenticateException());
        }
        if (response.statusCode == 500) {
          throw(InternalException(message: response.data['message'] ?? 'Đã xảy ra lỗi ngoài ý muốn'));
        }
        if ( response.statusCode == 400 || response.data["success"] == false) {
          throw(ResponseException(message: response.data['message']??'Sai cú pháp'));
        }
          throw(ResponseException(
              message: "Đã có lỗi xảy ra (${response.statusCode ?? ''}) "));
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout || e.error.runtimeType == SocketException) {
        throw(InternetException());
      }
      throw(ResponseException(message: "Đã xảy ra lỗi ngoài ý muốn, vui lòng chờ trong giây lát"));
    }
  }

  Future<Response> postResponse({required String path, dynamic data}) async{
      try {
        print('POST ${client.options.baseUrl}$path $data}' );
        final response = await client.post(path, data: data);
        print('POST $path: ${response.data}');
        if (response.statusCode == 200 && response.data['success'] == true) {
          return response;
        }
        if (response.statusCode == 403 || response.statusCode == 401) {
          throw(UnAuthenticateException());
        }
          if (response.statusCode == 500) {
            throw(InternalException(message: response.data['message'] ?? 'Đã xảy ra lỗi ngoài ý muốn'));
        }
        if ( response.statusCode == 400 || response.data["success"] == false) {
          throw(ResponseException(message: response.data['message'] ?? 'Sai cú pháp'));
        }
        throw(ResponseException(
            message: "Đã có lỗi xảy ra (${response.statusCode ?? ''}) "));

      } on DioError catch (e) {
        print(e);
        if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout || e.error.runtimeType == SocketException) {
          throw(InternetException());
        }
        throw(ResponseException(message: "Đã xảy ra lỗi ngoài ý muốn, vui lòng chờ trong giây lát"));
      }
  }


  void setBearerAuth({required String token}) {
     client.options.headers.addAll({'Authorization': 'Bearer $token'});
  }
  void setFormData(){
    client.options.contentType = Headers.formUrlEncodedContentType;
  }
  void setJson(){
    client.options.contentType = Headers.jsonContentType;
  }
  void addInterceptor(Interceptor interceptor) {
    client.interceptors.add(interceptor);
  }

  void setValidateStatus(ValidateStatus validateStatus) {
    client.options.validateStatus = validateStatus;
  }
  void setHeader(int version){
    client.options.headers.addAll({
      'VersionCodeSp': '$version'});
  }

}
