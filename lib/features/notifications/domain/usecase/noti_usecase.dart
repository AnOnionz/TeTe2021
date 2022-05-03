import 'package:dartz/dartz.dart';
import '../../../../features/notifications/domain/entity/noti_entity.dart';
import '../../../../features/notifications/domain/repositories/noti_repository.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/login/domain/entities/login_entity.dart';



class NotifyUseCase implements UseCase<List<NotifyEntity>, NotifyParams>{
  final NotifyRepository repository;

  NotifyUseCase({required this.repository});
  @override
  Future<Either<Failure, List<NotifyEntity>>> call(NotifyParams params) async  {
    final notify = await repository.fetchNotify(type: params.type);
    return notify ;
  }
}
class NotifyParams extends Params{
  final int type;

  NotifyParams({required this.type});
}