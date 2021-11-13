import 'package:tete2021/core/api/myDio.dart';
import 'package:tete2021/features/notifications/domain/entity/noti_entity.dart';

abstract class NotifyRemoteDataSource {
  Future<List<NotifyEntity>> fetchNotify();
  Future<bool> readAllNotify();
}
class NotifyRemoteDataSourceImpl extends NotifyRemoteDataSource{
  final CDio cDio;

  NotifyRemoteDataSourceImpl({required this.cDio});

  @override
  Future<List<NotifyEntity>> fetchNotify() async {
    Response _resp = await cDio.getResponse(path:'home/notification?page=0');
    return _resp.data['data'] != null ? (_resp.data['data'] as List<dynamic>).map((e) => NotifyEntity.fromJson(e)).toList() : [];
  }

  @override
  Future<bool> readAllNotify() async {
    await cDio.getResponse(path:'home/read-all-notification');
    return true;
  }

}