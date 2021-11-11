import '../../../../core/api/myDio.dart';

abstract class SamplingUseRemoteDataSource {
  Future<bool> saveSamplingUse();
}
class SamplingUseRemoteDataSourceImpl implements SamplingUseRemoteDataSource{
  final CDio cDio;

  SamplingUseRemoteDataSourceImpl({required this.cDio});

  @override
  Future<bool> saveSamplingUse() async {
    return true;
  }

}