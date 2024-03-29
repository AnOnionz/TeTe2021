import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failure.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params params);
}
class Params extends Equatable{
  @override
  List<Object> get props => [];

}
class NoParams extends Equatable{
  @override
  List<Object> get props => [];

}
