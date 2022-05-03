import '../../../../core/entities/data_local_entity.dart';

import '../../../../core/api/myDio.dart';

abstract class SamplingUseRemoteDataSource {
  Future<bool> saveSamplingUse({required DataLocalEntity samplingUse});
}
class SamplingUseRemoteDataSourceImpl implements SamplingUseRemoteDataSource{
  final CDio cDio;

  SamplingUseRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveSamplingUse({required DataLocalEntity samplingUse}) async {
    final sampling = samplingUse.data.map((e) => {"product_id" : e.id, "qty": e.value}).toList();
    final data = {"type": "USED", "data": sampling};

    Response _resp = await cDio.postResponse(path: 'home/oos', data: data);
    return _resp.data['success'];

  }

}