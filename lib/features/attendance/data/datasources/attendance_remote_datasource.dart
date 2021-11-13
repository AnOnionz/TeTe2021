import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_info.dart';
import 'package:tete2021/features/attendance/domain/entities/attendance_status.dart';
import '../../../../core/api/myDio.dart';
import '../../../../features/attendance/domain/entities/attendance_entity.dart';
import '../../../../features/attendance/domain/entities/attendance_type.dart';
import '../../../../features/login/presentation/blocs/authentication_bloc.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceInfo> checkSP({required AttendanceType type,required String spCode});
  Future<AttendanceStatus> checkInOrOut({required AttendanceEntity entity});
}
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource{
  final CDio cDio;

  AttendanceRemoteDataSourceImpl({required this.cDio});
  @override
  Future<AttendanceStatus> checkInOrOut({required AttendanceEntity entity}) async{
    FormData _formData = FormData.fromMap({
      'type': entity.type.value,
      'lat': entity.position.latitude,
      'lng': entity.position.longitude,
      'sp_code': entity.spCode.map((e) => [e.split(' ')[0]]).toList(),
      'image': MultipartFile.fromFileSync(
        entity.image.path,
        filename: basename(entity.image.path),
      ),
    });
    print(_formData.fields);
    cDio.setFormData();
    await cDio.postResponse(path: 'home/check-in-out-multi', data: _formData).whenComplete(() => cDio.setJson());
    return  AttendanceStatus.success;
  }

  @override
  Future<AttendanceInfo> checkSP({required AttendanceType type,required String spCode}) async {

    FormData _formData = FormData.fromMap({
      'type': type.value,
      'sp_code': spCode,
    });
    Response _resp = await cDio.postResponse(path: 'home/check', data: _formData);
    return AttendanceInfo.fromJson(_resp.data['data']);
  }

}