import '../../../../core/entities/data_local_entity.dart';

import '../../../../core/api/myDio.dart';

abstract class InventoryRemoteDataSource {
  Future<bool> saveInventory({required String type, required DataLocalEntity inventory});
}
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource{
  final CDio cDio;

  InventoryRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveInventory({required String type, required DataLocalEntity inventory}) async {
    final sampling = inventory.data.map((e) => {"product_id" : e.id, "qty": e.value}).toList();
    final data = {"type": type, "data": sampling};

    Response _resp = await cDio.postResponse(path: 'home/oos', data: data);
    return _resp.data['success'];
  }

}