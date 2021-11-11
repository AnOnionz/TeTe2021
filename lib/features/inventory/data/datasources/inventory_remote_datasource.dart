import '../../../../core/api/myDio.dart';

abstract class InventoryRemoteDataSource {
  Future<bool> saveInventory();
}
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource{
  final CDio cDio;

  InventoryRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveInventory() async {
    return true;
  }

}