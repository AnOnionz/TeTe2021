// import 'package:biaviet_offtrade/core/error/Exception.dart';
// import 'package:biaviet_offtrade/core/error/failure.dart';
// import 'package:biaviet_offtrade/core/platform/network_info.dart';
// import 'package:biaviet_offtrade/core/usecases/usecase.dart';
// import 'package:biaviet_offtrade/features/home/data/datasources/dashboard_local_datasouce.dart';
// import 'package:biaviet_offtrade/features/home/domain/repositories/dashboard_repository.dart';
// import 'package:dartz/dartz.dart';
//
//
// class DataTodayUseCase extends UseCase<bool, NoParams> {
//   final DashboardRepository repository;
//   final NetworkInfo networkInfo;
//   final DashBoardLocalDataSource local;
//
//   DataTodayUseCase(
//       {required this.repository,required  this.networkInfo, required this.local});
//   @override
//   Future<Either<Failure, bool>> call(NoParams params) async {
//     if (await networkInfo.isConnected) {
//       try {
//         if (!local.dataToday.isCheckIn) {
//           // await repository.saveSetGiftFromServer();
//           // await repository.saveSetGiftSBFromServer();
//           // await repository.saveSetGiftCurrentFromServer();
//           // await repository.saveSetGiftSBCurrentFromServer();
//           await repository.savePosmFromServer();
//           await local.cacheDataToday(loadData: true);
//
//         }
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
//     } else {
//       return Left(InternetFailure());
//     }
//   }
// }
