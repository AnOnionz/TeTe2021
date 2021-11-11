import '../../../../core/api/myDio.dart';

abstract class SamplingInventoryRemoteDataSource {
  Future<bool> saveSamplingInventory();
}
class SamplingInventoryRemoteDataSourceImpl implements SamplingInventoryRemoteDataSource{
  final CDio cDio;

  SamplingInventoryRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveSamplingInventory() async {
    return true;
  }

}