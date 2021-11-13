import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
// ignore: must_be_immutable
abstract class Failure extends Equatable{
    String message ;
    Failure(mess) : message = mess;

    @override
  String toString() {
    return message;
  }
    @override
  List<Object> get props => [message];
}
// ignore: must_be_immutable
class InternalFailure extends Failure{
  InternalFailure({required String message}): super(message);

}
// ignore: must_be_immutable
class UnAuthenticateFailure extends Failure{
  UnAuthenticateFailure(): super("Phiên đăng nhập đã hết hạn");

}
// ignore: must_be_immutable
class ResponseFailure extends Failure{
  ResponseFailure({message}): super(message);
}
// ignore: must_be_immutable
class InternetFailure extends Failure{
  InternetFailure() : super("Không có kết nối internet");
}
// ignore: must_be_immutable
class InvalidFailure extends Failure{
  InvalidFailure({message}) : super(message);
}
// ignore: must_be_immutable
class HasSyncFailure extends Failure{
  HasSyncFailure({message}) : super('Yêu đồng bộ dữ liệu trước khi chấm công ra');
}
// ignore: must_be_immutable
class CheckInNullFailure extends Failure{
  CheckInNullFailure({message}): super(message);
}
// ignore: must_be_immutable
class SaleNullFailure extends Failure{
  SaleNullFailure(): super("Yêu cầu nhập số bán theo ca");
}
// ignore: must_be_immutable
class SamplingUseNullFailure extends Failure{
  SamplingUseNullFailure(): super("Yêu cầu nhập sampling sử dụng");
}
// ignore: must_be_immutable
class InventoryInNullFailure extends Failure{
  InventoryInNullFailure(): super("Yêu cầu nhập tồn kho đầu");
}
// ignore: must_be_immutable
class InventoryOutNullFailure extends Failure{
  InventoryOutNullFailure(): super("Yêu cầu nhập tồn kho cuối");
}
// ignore: must_be_immutable
class FailureAndCachedToLocal extends Failure{
  FailureAndCachedToLocal(message): super(message);
}

