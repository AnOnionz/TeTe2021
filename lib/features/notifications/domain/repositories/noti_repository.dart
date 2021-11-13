import 'package:dartz/dartz.dart';
import 'package:tete2021/core/error/failure.dart';
import 'package:tete2021/features/notifications/domain/entity/noti_entity.dart';

abstract class NotifyRepository{
  Future<Either<Failure, List<NotifyEntity>>> fetchNotify({required int type});
}