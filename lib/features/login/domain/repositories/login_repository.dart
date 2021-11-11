import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/login/domain/entities/login_entity.dart';

abstract class LoginRepository{
  Future<Either<Failure, LoginEntity>> login({required String username, required String password});
  Future<Either<Failure, bool>> logout();
}