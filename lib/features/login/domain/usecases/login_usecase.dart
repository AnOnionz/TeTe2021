import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/login/domain/entities/login_entity.dart';
import '../../../../features/login/domain/repositories/login_repository.dart';


class LoginUseCase implements UseCase<LoginEntity, LoginParams>{
  final LoginRepository repository;

  LoginUseCase({required this.repository});
  @override
  Future<Either<Failure, LoginEntity>> call(LoginParams params) async  {
    final login = await repository.login(username: params.username, password: params.password);
    return login ;
  }
}
class LoginParams extends Params {
  final String username;
  final String password;

  LoginParams({required this.username,required this.password});

}