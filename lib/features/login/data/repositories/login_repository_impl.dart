import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/api/myDio.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../features/login/data/datasources/login_remote_datasource.dart';
import '../../../../features/login/domain/entities/login_entity.dart';
import '../../../../features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final NetworkInfo networkInfo;
  final LoginRemoteDataSource loginRemoteDataSource;
  LoginRepositoryImpl(
      {required this.loginRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final logout = await loginRemoteDataSource.logout();
      return Right(logout);
    } on InternetException catch (_) {
      return Left(InternetFailure());
    } on UnAuthenticateException catch (_) {
      return Left(UnAuthenticateFailure());
    } on ResponseException catch (error) {
      return Left(ResponseFailure(message: error.message));
    } on InternalException catch (error) {
      return Left(InternalFailure(message: error.message));
    } catch (error) {
      return Left(ResponseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginEntity>> login(
      {required String username, required String password}) async {

      try {
        final login = await loginRemoteDataSource.login(
            username: username, password: password);
        return Right(login);
      } on InternetException catch (_) {
        return Left(InternetFailure());
      } on UnAuthenticateException catch (_) {
        return Left(UnAuthenticateFailure());
      } on ResponseException catch (error) {
        return Left(ResponseFailure(message: error.message));
      } on InternalException catch (error) {
        return Left(InternalFailure(message: error.message));
      } catch (error) {
        return Left(ResponseFailure(message: error.toString()));
      }
  }
}
