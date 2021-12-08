import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/home/domain/repositories/dashboard_repository.dart';

class SaveDataToLocalUseCase implements UseCase<bool, NoParams>{
  final DashboardRepository repository;
  final NetworkInfo networkInfo;

  SaveDataToLocalUseCase({required this.repository, required this.networkInfo});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await repository.saveProductFromServer();
        await repository.saveDataToday();
        return const Right(true);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } catch (error){
        print(error.toString());
        return Left(ResponseFailure(message: error.toString()));
      }
    }else{
      return Left(InternetFailure());
    }
  }
}