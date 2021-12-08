import '../../../../core/entities/data_local_entity.dart';

import '../../../../core/api/myDio.dart';

abstract class SamplingInventoryRemoteDataSource {
  Future<bool> saveSamplingInventory({required DataLocalEntity samplingInventory});
}
class SamplingInventoryRemoteDataSourceImpl implements SamplingInventoryRemoteDataSource{
  final CDio cDio;

  SamplingInventoryRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveSamplingInventory({required DataLocalEntity samplingInventory}) async {
    final sampling = samplingInventory.data.map((e) => {"product_id" : e.id, "qty": e.value}).toList();
    final data = {"type": "SAMPLING", "data": sampling};
    Response _resp = await cDio.postResponse(path: 'home/oos', data: data);
    print(_resp);
    return _resp.data['success'];

  }

}