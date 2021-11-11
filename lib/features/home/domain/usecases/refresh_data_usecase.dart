// import 'package:biaviet_offtrade/core/error/Exception.dart';
// import 'package:biaviet_offtrade/core/error/failure.dart';
// import 'package:biaviet_offtrade/core/platform/network_info.dart';
// import 'package:biaviet_offtrade/core/usecases/usecase.dart';
// import 'package:biaviet_offtrade/features/home/domain/repositories/dashboard_repository.dart';
// import 'package:dartz/dartz.dart';
//
//
// class RefreshDataUseCase implements UseCase<bool, NoParams>{
//   final DashboardRepository repository;
//   final NetworkInfo networkInfo;
//
//   RefreshDataUseCase({required this.repository,required this.networkInfo});
//   @override
//   Future<Either<Failure, bool>> call(NoParams params) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await repository.saveGiftFromServer();
//         //await repository.saveGiftStrongbowFromServer();
//         await repository.saveProductFromServer() ;
//         //await repository.saveRivalProductFromServer();
//         //await repository.saveSetGiftFromServer();
//         //await repository.saveSetGiftSBFromServer();
//         //await repository.saveSetGiftCurrentFromServer();
//        // await repository.saveSetGiftSBCurrentFromServer();
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
// }