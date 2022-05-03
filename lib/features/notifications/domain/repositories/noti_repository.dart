import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../features/notifications/domain/entity/noti_entity.dart';

abstract class NotifyRepository{
  Future<Either<Failure, List<NotifyEntity>>> fetchNotify({required int type});
}