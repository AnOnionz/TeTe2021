// import 'package:biaviet_offtrade/core/error/Exception.dart';
// import 'package:biaviet_offtrade/core/error/failure.dart';
// import 'package:biaviet_offtrade/core/platform/network_info.dart';
// import 'package:biaviet_offtrade/core/usecases/usecase.dart';
// import 'package:biaviet_offtrade/features/home/domain/repositories/dashboard_repository.dart';
// import 'package:dartz/dartz.dart';
//
// class ReloadPosmUseCase extends UseCase<bool, NoParams>{
//   final DashboardRepository repository;
//   final NetworkInfo networkInfo;
//
//   ReloadPosmUseCase({required this.repository,required this.networkInfo});
//   @override
//   Future<Either<Failure, bool>> call(NoParams params) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await repository.savePosmFromServer();
//         return Right(true);
//       } on InternetException catch (_) {
//         return Left(InternetFailure());
//       } on ResponseException catch (error) {
//         return Left(ResponseFailure(message: error.message));
//       } on UnAuthenticateException catch (_) {
//         return Left(UnAuthenticateFailure());
//       } on InternalException catch (_) {
//         return Left(InternalFailure());
//       }
//     }else{
//       return Left(InternetFailure());
//     }
//   }
//
// }