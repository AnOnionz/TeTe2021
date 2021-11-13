import 'package:tete2021/core/entities/data_local_entity.dart';

import '../../../../core/api/myDio.dart';

abstract class SaleRemoteDataSource {
  Future<bool> saveSale({required DataLocalEntity sale});
}
class SaleRemoteDataSourceImpl implements SaleRemoteDataSource{
  final CDio cDio;

  SaleRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveSale({required DataLocalEntity sale}) async {
    final data = {"data": sale.data.map((e) => {"product_id" : e.id, "qty": e.value}).toList()};

    Response _resp = await cDio.postResponse(path: 'home/otv', data: data);
    return _resp.data['success'];

  }

}